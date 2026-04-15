import csv
import matplotlib.pyplot as plt
import os

FILE_NAME = "expense.csv"

# ---------------- ADD EXPENSE ----------------
def add_expense():
    date = input("Enter date (DD-MM-YYYY): ")

    if len(date) != 10 or date[2] != '-' or date[5] != '-':
        print("Invalid date format!")
        return

    category = input("Enter category (Food, Travel, Bills, Others): ")

    try:
        amount = float(input("Enter amount: "))
    except ValueError:
        print("Invalid amount!")
        return

    description = input("Enter description: ")

    data = {
        "date": date,
        "category": category,
        "amount": amount,
        "description": description
    }

    file_exists = os.path.isfile(FILE_NAME)

    with open(FILE_NAME, mode="a", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=data.keys())
        if not file_exists:
            writer.writeheader()
        writer.writerow(data)

    print("Expense added successfully!")

# ---------------- VIEW ----------------
def view_expenses():
    if not os.path.exists(FILE_NAME):
        print("No data found.")
        return

    with open(FILE_NAME, "r") as file:
        reader = csv.DictReader(file)
        for row in reader:
            print(row)

# ---------------- MONTHLY SUMMARY ----------------
def monthly_summary():
    if not os.path.exists(FILE_NAME):
        print("No data found.")
        return

    month = input("Enter month and year (MM-YYYY): ")

    total = 0

    with open(FILE_NAME, "r") as file:
        reader = csv.DictReader(file)
        for row in reader:
            if row['date'][3:] == month:
                total += float(row['amount'])

    print(f"Total expense for {month}: ₹{total:.2f}")

# ---------------- CATEGORY ANALYSIS ----------------
def category_analysis():
    if not os.path.exists(FILE_NAME):
        print("No data found.")
        return

    categories = {}

    with open(FILE_NAME, "r") as file:
        reader = csv.DictReader(file)
        for row in reader:
            cat = row['category']
            amt = float(row['amount'])

            if cat in categories:
                categories[cat] += amt
            else:
                categories[cat] = amt

    for cat, amt in categories.items():
        print(f"{cat}: ₹{amt:.2f}")

    # Highest spending category
    if categories:
        max_cat = max(categories, key=categories.get)
        print(f"\nHighest spending category: {max_cat} (₹{categories[max_cat]:.2f})")

# ---------------- PLOT ----------------
def plot_expenses():
    if not os.path.exists(FILE_NAME):
        print("No data found.")
        return

    categories = {}

    with open(FILE_NAME, "r") as file:
        reader = csv.DictReader(file)
        for row in reader:
            cat = row['category']
            amt = float(row['amount'])

            if cat in categories:
                categories[cat] += amt
            else:
                categories[cat] = amt

    labels = list(categories.keys())
    values = list(categories.values())

    if sum(values) == 0:
        print("No data to plot.")
        return

    plt.figure(figsize=(8, 8))
    plt.pie(values, labels=labels, autopct="%1.1f%%")
    plt.title("Category-wise Expense Distribution")
    plt.show()

# ---------------- INSIGHTS ----------------
def insights():
    if not os.path.exists(FILE_NAME):
        print("No data found.")
        return

    total = 0
    categories = {}

    with open(FILE_NAME, "r") as file:
        reader = csv.DictReader(file)
        for row in reader:
            amt = float(row['amount'])
            total += amt

            cat = row['category']
            categories[cat] = categories.get(cat, 0) + amt

    if not categories:
        print("No data available.")
        return

    max_cat = max(categories, key=categories.get)

    print(f"\nTotal Spending: ₹{total:.2f}")
    print(f"Highest Spending Category: {max_cat}")

    print("\nSuggestion:")
    print(f"Try reducing expenses in '{max_cat}' category to save more money.")

# ---------------- MAIN ----------------
def main():
    while True:
        print("\n--- Smart Expense Tracker ---")
        print("1. Add Expense")
        print("2. View Expenses")
        print("3. Monthly Summary")
        print("4. Category Analysis")
        print("5. Show Pie Chart")
        print("6. Get Insights")
        print("7. Exit")

        choice = input("Enter your choice: ")

        if choice == "1":
            add_expense()
        elif choice == "2":
            view_expenses()
        elif choice == "3":
            monthly_summary()
        elif choice == "4":
            category_analysis()
        elif choice == "5":
            plot_expenses()
        elif choice == "6":
            insights()
        elif choice == "7":
            print("Exiting...")
            break
        else:
            print("Invalid choice!")

if __name__ == "__main__":
    main()