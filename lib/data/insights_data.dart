class InsightsTransaction {
  const InsightsTransaction({
    required this.name,
    required this.date,
    required this.amount,
  });

  final String name;
  final String date;
  final double amount;
}

class InsightsCategory {
  const InsightsCategory({
    required this.name,
    required this.emoji,
    required this.amount,
    this.transactions = const [],
  });

  final String name;
  final String emoji; // rendered as plain text, not IconData — matches design
  final double amount;
  final List<InsightsTransaction> transactions;
}

class InsightsMonthData {
  const InsightsMonthData({
    required this.monthLabel,
    required this.total,
    required this.categories,
  });

  final String monthLabel;
  final double total;
  final List<InsightsCategory> categories;
}

const List<InsightsMonthData> mockInsightsData = [
  InsightsMonthData(
    monthLabel: 'Sep',
    total: 900,
    categories: [
      InsightsCategory(
        name: 'Groceries',
        emoji: '🛒',
        amount: 600,
        transactions: [
          InsightsTransaction(
            name: 'La Colonia',
            date: '01.09.2024',
            amount: 350,
          ),
          InsightsTransaction(
            name: 'Supermercados',
            date: '15.09.2024',
            amount: 250,
          ),
        ],
      ),
      InsightsCategory(
        name: 'Shopping',
        emoji: '🛍️',
        amount: 300,
        transactions: [
          InsightsTransaction(
            name: 'City Mall',
            date: '10.09.2024',
            amount: 180,
          ),
          InsightsTransaction(
            name: 'Multiplaza',
            date: '22.09.2024',
            amount: 120,
          ),
        ],
      ),
    ],
  ),
  InsightsMonthData(
    monthLabel: 'Oct',
    total: 1200,
    categories: [
      InsightsCategory(
        name: 'Groceries',
        emoji: '🛒',
        amount: 700,
        transactions: [
          InsightsTransaction(
            name: 'La Colonia',
            date: '05.10.2024',
            amount: 400,
          ),
          InsightsTransaction(
            name: 'PriceSmart',
            date: '20.10.2024',
            amount: 300,
          ),
        ],
      ),
      InsightsCategory(
        name: 'Entertainment',
        emoji: '🎮',
        amount: 500,
        transactions: [
          InsightsTransaction(name: 'Netflix', date: '01.10.2024', amount: 200),
          InsightsTransaction(
            name: 'Cinemark',
            date: '14.10.2024',
            amount: 300,
          ),
        ],
      ),
    ],
  ),
  InsightsMonthData(
    monthLabel: 'Nov',
    total: 1100,
    categories: [
      InsightsCategory(
        name: 'Groceries',
        emoji: '🛒',
        amount: 800,
        transactions: [
          InsightsTransaction(
            name: 'La Colonia',
            date: '03.11.2024',
            amount: 500,
          ),
          InsightsTransaction(
            name: 'Supermercados',
            date: '18.11.2024',
            amount: 300,
          ),
        ],
      ),
      InsightsCategory(
        name: 'Shopping',
        emoji: '🛍️',
        amount: 300,
        transactions: [
          InsightsTransaction(
            name: 'City Mall',
            date: '11.11.2024',
            amount: 180,
          ),
          InsightsTransaction(
            name: 'Multiplaza',
            date: '25.11.2024',
            amount: 120,
          ),
        ],
      ),
    ],
  ),
  InsightsMonthData(monthLabel: 'Dec', total: 0, categories: []),
  InsightsMonthData(
    monthLabel: 'Jan',
    total: 950,
    categories: [
      InsightsCategory(
        name: 'Groceries',
        emoji: '🛒',
        amount: 500,
        transactions: [
          InsightsTransaction(
            name: 'La Colonia',
            date: '07.01.2025',
            amount: 300,
          ),
          InsightsTransaction(
            name: 'PriceSmart',
            date: '21.01.2025',
            amount: 200,
          ),
        ],
      ),
      InsightsCategory(
        name: 'Entertainment',
        emoji: '🎮',
        amount: 450,
        transactions: [
          InsightsTransaction(name: 'Netflix', date: '01.01.2025', amount: 200),
          InsightsTransaction(name: 'Spotify', date: '01.01.2025', amount: 250),
        ],
      ),
    ],
  ),
  InsightsMonthData(
    monthLabel: 'Feb',
    total: 2000,
    categories: [
      InsightsCategory(
        name: 'Groceries',
        emoji: '🛒',
        amount: 1000,
        transactions: [
          InsightsTransaction(
            name: 'La Colonia',
            date: '04.02.2025',
            amount: 600,
          ),
          InsightsTransaction(
            name: 'PriceSmart',
            date: '18.02.2025',
            amount: 400,
          ),
        ],
      ),
      InsightsCategory(
        name: 'Shopping',
        emoji: '🛍️',
        amount: 500,
        transactions: [
          InsightsTransaction(
            name: 'City Mall',
            date: '08.02.2025',
            amount: 300,
          ),
          InsightsTransaction(
            name: 'Multiplaza',
            date: '20.02.2025',
            amount: 200,
          ),
        ],
      ),
      InsightsCategory(
        name: 'Entertainment',
        emoji: '🎮',
        amount: 500,
        transactions: [
          InsightsTransaction(name: 'Netflix', date: '01.02.2025', amount: 200),
          InsightsTransaction(
            name: 'Cinemark',
            date: '14.02.2025',
            amount: 300,
          ),
        ],
      ),
    ],
  ),
];
