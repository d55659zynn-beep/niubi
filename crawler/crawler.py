#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
网申辅助 · 岗位爬虫（独立脚本，仅个人自用）
=========================================

职责：在电脑端抓取招聘网站的岗位列表，导出为 JSON 文件，
      再把 JSON 导入到手机 APP（APP 内不做任何抓取）。

⚠️ 使用须知
- 仅限个人自用，请遵守目标网站的 robots.txt 与用户协议；
- 所有请求都带随机延时（默认 2~5 秒），降低对站点的压力；
- 不要填写、提交任何表单，本脚本只读取公开列表页。

导出格式（与 APP 导入格式一致）：
{
  "source": "站点标识",
  "exportedAt": "2026-10-28T12:00:00",
  "jobs": [
    {
      "id": "站点内唯一id",
      "company": "公司名",
      "title": "岗位名",
      "city": "城市",
      "direction": "岗位方向（后端/前端/算法...）",
      "deadline": "截止日期 YYYY-MM-DD（可缺省）",
      "description": "岗位描述",
      "applyUrl": "投递页 URL（APP 内用 WebView 打开）"
    }
  ]
}

用法：
    python3 crawler.py --site sample --output jobs.json      # 演示示例
    python3 crawler.py --site nowcoder --output jobs.json    # 扩展真实站点
    python3 crawler.py --list                                 # 列出可用站点

依赖：仅 Python 3.9+ 标准库（urllib），无需 pip 安装任何包。
"""

import argparse
import json
import random
import sys
import time
import urllib.request
from dataclasses import dataclass
from datetime import datetime
from typing import List, Optional

# 浏览器 UA，尽量模拟真实访问
USER_AGENT = (
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
    "AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/126.0.0.0 Safari/537.36"
)

# 请求之间的随机延时范围（秒）—— 礼貌爬取，防止对站点造成压力
DELAY_MIN = 2.0
DELAY_MAX = 5.0

# 单次请求超时（秒）
TIMEOUT = 15


@dataclass
class JobItem:
    """一条岗位记录，字段与 APP 的导入格式一一对应。"""

    id: str  # 站点内唯一 id，用于去重（APP 按 source + id 去重）
    company: str
    title: str
    city: str = ""
    direction: str = ""  # 岗位方向：后端 / 前端 / 算法 / 测试 ...
    deadline: Optional[str] = None  # YYYY-MM-DD
    description: str = ""
    apply_url: str = ""


def fetch_page(url: str) -> str:
    """带 UA / 超时 / 重试 / 延时的页面抓取，返回 HTML 文本。

    每次请求前先随机延时（首个请求不延时，方便调试）。
    """
    global _first_request
    if not _first_request:
        delay = random.uniform(DELAY_MIN, DELAY_MAX)
        print(f"[延时] 等待 {delay:.1f}s 后请求：{url}")
        time.sleep(delay)
    _first_request = False

    last_err: Optional[Exception] = None
    for attempt in range(1, 4):  # 最多重试 3 次
        try:
            req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
            with urllib.request.urlopen(req, timeout=TIMEOUT) as resp:
                # 部分站点按 UTF-8 返回，个别为 GBK，这里先按 UTF-8 尝试
                data = resp.read()
                try:
                    return data.decode("utf-8")
                except UnicodeDecodeError:
                    return data.decode("gbk", errors="replace")
        except Exception as e:  # noqa: BLE001
            last_err = e
            print(f"[重试] 第 {attempt} 次失败：{e}")
            time.sleep(delay if attempt > 1 else 1)
    raise RuntimeError(f"抓取失败：{url}，最后错误：{last_err}")


def export_json(source: str, jobs: List[JobItem], output: str) -> None:
    """把岗位列表写成 APP 可导入的 JSON 文件。

    注意：字段名与 APP 导入格式保持一致，使用 camelCase（applyUrl）。
    """
    payload = {
        "source": source,
        "exportedAt": datetime.now().isoformat(timespec="seconds"),
        "jobs": [
            {
                "id": j.id,
                "company": j.company,
                "title": j.title,
                "city": j.city,
                "direction": j.direction,
                "deadline": j.deadline,
                "description": j.description,
                # APP 读取的键名是 applyUrl（camelCase）
                "applyUrl": j.apply_url,
            }
            for j in jobs
        ],
    }
    with open(output, "w", encoding="utf-8") as f:
        json.dump(payload, f, ensure_ascii=False, indent=2)
    print(f"[完成] 导出 {len(jobs)} 条岗位到 {output}")


def _html_escape(text: str) -> str:
    """简单 HTML 实体还原，清理描述文本里的标签与空白。"""
    return (
        text.replace("&nbsp;", " ")
        .replace("&amp;", "&")
        .replace("&lt;", "<")
        .replace("&gt;", ">")
        .strip()
    )


# ---------------------------------------------------------------------------
# 站点适配器：每个网站写一个 parse(list_page_html) 函数即可接入。
# 示例站点（sample）演示完整流程；真实站点请仿照编写。
# ---------------------------------------------------------------------------


def parse_sample(html: str) -> List[JobItem]:
    """示例站点解析：本地 HTML 演示文件，展示解析套路。

    真实站点解析通常是：先定位岗位卡片容器，再逐个提取字段。
    例如用正则或简单的字符串查找（避免额外依赖）：
      - 岗位名：<h2 class="job-title">后端开发实习生</h2>
      - 公司名：<span class="company">某某科技</span>
    写成：
      import re
      for m in re.finditer(r'<h2 class="job-title">(.*?)</h2>', html):
          title = _html_escape(m.group(1))
    """
    jobs: List[JobItem] = []
    # demo HTML 包含三张“岗位卡片”，逐块切分再提取字段
    cards = html.split('<div class="job-card">')[1:]
    for idx, card in enumerate(cards, start=1):
        title = _extract_between(card, '<span class="title">', "</span>")
        company = _extract_between(card, '<span class="company">', "</span>")
        city = _extract_between(card, '<span class="city">', "</span>")
        direction = _extract_between(card, '<span class="direction">', "</span>")
        deadline = _extract_between(card, '<span class="deadline">', "</span>")
        description = _extract_between(
            card, '<div class="description">', "</div>"
        )
        apply_url = _extract_between(card, 'href="', '"')
        jobs.append(
            JobItem(
                id=f"sample-{idx:03d}",
                company=_html_escape(company),
                title=_html_escape(title),
                city=_html_escape(city),
                direction=_html_escape(direction),
                deadline=deadline.strip() or None,
                description=_html_escape(description),
                apply_url=apply_url,
            )
        )
    return jobs


def _extract_between(text: str, start: str, end: str) -> str:
    """取 start 与 end 之间的第一个子串，找不到返回空串。"""
    i = text.find(start)
    if i < 0:
        return ""
    i += len(start)
    j = text.find(end, i)
    if j < 0:
        return text[i:]
    return text[i:j]


# 站点注册表：key 为 --site 参数值
SITES = {
    # 示例站点：使用本地 fixture，演示解析与导出，不访问网络
    "sample": {
        "name": "示例站点（本地演示）",
        "url": None,  # None 表示读本地文件
        "parser": parse_sample,
    },
    # 真实站点示例（需自行补充 URL 与解析规则）：
    # "nowcoder": {
    #     "name": "牛客网 · 实习广场",
    #     "url": "https://www.nowcoder.com/intern/center?...",
    #     "parser": parse_nowcoder,   # 仿照 parse_sample 编写
    # },
}

_first_request = True


def list_sites() -> None:
    """打印可用站点。"""
    print("可用站点：")
    for key, cfg in SITES.items():
        print(f"  {key:<12} {cfg['name']}")


def run(source: str, output: str) -> None:
    """执行抓取 → 解析 → 导出全流程。"""
    cfg = SITES.get(source)
    if cfg is None:
        print(f"未知站点：{source}，可用站点见 --list")
        sys.exit(1)

    url = cfg["url"]
    if url is None:
        # 本地演示：读取同目录 sample_jobs 的 HTML 变体（sample_pages.html）
        html_path = "sample_pages.html"
        print(f"[读取] 本地演示页面 {html_path}")
        try:
            with open(html_path, encoding="utf-8") as f:
                html = f.read()
        except FileNotFoundError:
            print(f"缺少演示文件 {html_path}，请先运行：python3 crawler.py --init-demo")
            sys.exit(1)
    else:
        html = fetch_page(url)

    print(f"[解析] 站点：{cfg['name']}")
    jobs = cfg["parser"](html)
    if not jobs:
        print("[警告] 未解析到任何岗位，请检查站点页面结构是否变化")
        sys.exit(1)

    export_json(source, jobs, output)


def init_demo() -> None:
    """生成本地演示页面 sample_pages.html（模拟招聘网站列表页）。"""
    demo = """<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>实习招聘 - 演示列表</title></head>
<body>
<div class="job-list">
  <div class="job-card">
    <a href="https://example.com/apply/backend-intern">
      <span class="title">后端开发实习生</span>
      <span class="company">示例科技</span>
      <span class="city">北京</span>
      <span class="direction">后端</span>
      <span class="deadline">2026-11-30</span>
      <div class="description">参与实习岗位接口开发。此条为示例数据，由电脑端脚本导出。</div>
    </a>
  </div>
  <div class="job-card">
    <a href="https://example.com/apply/frontend-intern">
      <span class="title">前端开发实习生</span>
      <span class="company">示例科技</span>
      <span class="city">上海</span>
      <span class="direction">前端</span>
      <span class="deadline">2026-12-15</span>
      <div class="description">负责内部工具前端页面开发与维护。</div>
    </a>
  </div>
  <div class="job-card">
    <a href="https://example.com/apply/algorithm-intern">
      <span class="title">算法实习生</span>
      <span class="company">示例研究院</span>
      <span class="city">杭州</span>
      <span class="direction">算法</span>
      <span class="deadline">2026-11-10</span>
      <div class="description">参与推荐算法调研与实验。</div>
    </a>
  </div>
</div>
</body></html>
"""
    with open("sample_pages.html", "w", encoding="utf-8") as f:
        f.write(demo)
    print("[完成] 已生成演示页面 sample_pages.html")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="网申辅助岗位爬虫（独立脚本，仅个人自用）"
    )
    parser.add_argument("--site", default="sample", help="站点标识，见 --list")
    parser.add_argument("--output", default="jobs.json", help="导出 JSON 路径")
    parser.add_argument("--list", action="store_true", help="列出可用站点")
    parser.add_argument("--init-demo", action="store_true", help="生成本地演示页面")
    args = parser.parse_args()

    if args.list:
        list_sites()
        return
    if args.init_demo:
        init_demo()
        return
    run(args.site, args.output)


if __name__ == "__main__":
    main()