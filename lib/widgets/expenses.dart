import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/widgets/chart/chart.dart';
import 'package:expense_tracker_app/widgets/expenses_list/expense_list.dart';
import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/data/expense_data.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpenseState();
  }
}

class _ExpenseState extends State<Expenses> {
  void _openAddExpenseOverlay() {
    //..
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(addToExpenseList),
    );
  }

  void addToExpenseList(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }

  void removeFromExpenseList(int index) {
    final Expense expenseAtIndex = expenses[index];
    setState(() {
      expenses.removeAt(index);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      action: SnackBarAction(
        label: "Undo",
        onPressed: () {
          setState(() {
            expenses.insert(index, expenseAtIndex);
          });
        },
      ),
      duration: const Duration(seconds: 3),
      content: const Text("Expense Deleted"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text("No expense found, Start adding some "),
    );

    if (expenses.isNotEmpty) {
      mainContent = ExpenseList(
        expenses: expenses,
        removeExpense: removeFromExpenseList,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Expense Tracker"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          //Toolbar with the Add  button ==> Row() - one of the options
          Chart(expenses: expenses),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
