import 'package:flutter/material.dart';

class DefaultTable extends StatelessWidget {
  final List<List<Widget>> rows;

  const DefaultTable({
    required this.rows,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        for (int i = 0; i < rows.length; i++)
          TableRow(
            decoration: BoxDecoration(
              color: i % 2 == 0 ? Colors.grey[200] : null,
            ),
            children: [
              for (var item in rows[i])
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  child: item,
                ),
            ],
          ),
      ],
    );
  }
}
