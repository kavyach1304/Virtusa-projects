import java.util.ArrayList;
import java.util.Scanner;

// Custom Exception
class InSufficientFundsException extends Exception {
    public InSufficientFundsException(String message) {
        super(message);
    }
}

// Account Class (Encapsulation)
class Account {

    private String accountHolder;
    private double balance;

    // Store last 5 successful transactions
    private ArrayList<Double> transactionHistory;

    // Constructor
    public Account(String accountHolder, double balance) {
        this.accountHolder = accountHolder;
        this.balance = balance;
        transactionHistory = new ArrayList<>();
    }

    // Getter Methods
    public String getAccountHolder() {
        return accountHolder;
    }

    public double getBalance() {
        return balance;
    }

    // Deposit Method
    public void deposit(double amount) {

        if (amount <= 0) {
            throw new IllegalArgumentException("Deposit amount must be positive.");
        }

        balance += amount;

        addTransaction(amount);

        System.out.println("Deposit Successful!");
        System.out.println("Current Balance: ₹" + balance);
    }

    // Withdraw / Process Transaction
    public void processTransaction(double amount)
            throws InSufficientFundsException {

        // Negative Amount Check
        if (amount < 0) {
            throw new IllegalArgumentException(
                    "Transaction amount cannot be negative.");
        }

        // Insufficient Balance Check
        if (amount > balance) {
            throw new InSufficientFundsException(
                    "Insufficient balance! Transaction failed.");
        }

        balance -= amount;

        addTransaction(-amount);

        System.out.println("Withdrawal Successful!");
        System.out.println("Remaining Balance: ₹" + balance);
    }

    // Store only last 5 transactions
    private void addTransaction(double amount) {

        if (transactionHistory.size() == 5) {
            transactionHistory.remove(0);
        }

        transactionHistory.add(amount);
    }

    // Print Mini Statement
    public void printMiniStatement() {

        System.out.println("\n===== MINI STATEMENT =====");

        if (transactionHistory.isEmpty()) {
            System.out.println("No transactions available.");
        } else {

            for (int i = 0; i < transactionHistory.size(); i++) {

                double amt = transactionHistory.get(i);

                if (amt > 0) {
                    System.out.println((i + 1) +
                            ". Deposited: ₹" + amt);
                } else {
                    System.out.println((i + 1) +
                            ". Withdrawn: ₹" + Math.abs(amt));
                }
            }
        }

        System.out.println("Current Balance: ₹" + balance);
        System.out.println("==========================\n");
    }
}


public class FinSafeApp {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        // Create Account
        Account acc = new Account("Kavya", 5000);

        int choice;

        do {

            System.out.println("\n====== FinSafe Wallet ======");
            System.out.println("1. Deposit");
            System.out.println("2. Withdraw");
            System.out.println("3. View Mini Statement");
            System.out.println("4. Check Balance");
            System.out.println("5. Exit");
            System.out.print("Enter your choice: ");

            choice = sc.nextInt();

            try {

                switch (choice) {

                    case 1:
                        System.out.print("Enter deposit amount: ");
                        double depositAmount = sc.nextDouble();

                        acc.deposit(depositAmount);
                        break;

                    case 2:
                        System.out.print("Enter withdrawal amount: ");
                        double withdrawAmount = sc.nextDouble();

                        acc.processTransaction(withdrawAmount);
                        break;

                    case 3:
                        acc.printMiniStatement();
                        break;

                    case 4:
                        System.out.println("Current Balance: ₹" +
                                acc.getBalance());
                        break;

                    case 5:
                        System.out.println("Thank you for using FinSafe!");
                        break;

                    default:
                        System.out.println("Invalid Choice!");
                }

            }
            // Custom Exception Handling
            catch (InSufficientFundsException e) {
                System.out.println("ERROR: " + e.getMessage());
            }

            // Illegal Argument Handling
            catch (IllegalArgumentException e) {
                System.out.println("ERROR: " + e.getMessage());
            }

            // Any Other Exception
            catch (Exception e) {
                System.out.println("Unexpected Error: " + e.getMessage());
            }

            finally {
                System.out.println("Transaction attempt finished.");
            }

        } while (choice != 5);

        sc.close();
    }
}