import json
import csv
from datetime import datetime

def load_config():
    with open("Helpers/config.json", "r") as f:
        return json.load(f)

def load_students():
    students = []
    with open("Helpers/assets.csv", "r") as f:
        reader = csv.DictReader(f)
        for row in reader:
            students.append(row)
    return students

def check_attendance(students, config):
    warning_threshold = config.get("warning", 75)
    failure_threshold = config.get("failure", 50)
    results = []
    for student in students:
        name = student["name"]
        attended = int(student["attended"])
        total = int(student["total"])
        percentage = (attended / total) * 100 if total > 0 else 0
        if percentage < failure_threshold:
            status = "FAIL"
        elif percentage < warning_threshold:
            status = "WARNING"
        else:
            status = "OK"
        results.append({"name": name, "attended": attended, "total": total, "percentage": round(percentage, 2), "status": status})
    return results

def write_report(results):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open("reports/reports.log", "a") as f:
        f.write(f"\n=== Attendance Report — {timestamp} ===\n")
        for r in results:
            f.write(f"{r['name']}: {r['percentage']}% — {r['status']}\n")
    print("Report written to reports/reports.log")

if __name__ == "__main__":
    config = load_config()
    students = load_students()
    results = check_attendance(students, config)
    for r in results:
        print(f"{r['name']}: {r['percentage']}% — {r['status']}")
    write_report(results)
