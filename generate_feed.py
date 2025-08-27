import json
from datetime import datetime


def load_passages(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        return json.load(f)


def format_passage(passage):
    dt = datetime.fromisoformat(passage["heure"].replace("Z", "+00:00"))
    return {
        "nom": passage["nom"],
        "station": passage["station"],
        "date": dt.strftime("%Y-%m-%d"),
        "heure": dt.strftime("%H:%M"),
    }


def generate_feed(passages):
    return [format_passage(p) for p in passages]


def save_feed(feed, output_path):
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(feed, f, indent=2, ensure_ascii=False)


if __name__ == "__main__":
    data = load_passages("passages.json")
    feed = generate_feed(data)
    save_feed(feed, "shopify-feed.json")
