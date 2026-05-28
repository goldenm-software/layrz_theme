import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/store/store.dart';

class ResponsiveRowShowcaseView extends StatefulWidget {
  const ResponsiveRowShowcaseView({super.key});

  @override
  State<ResponsiveRowShowcaseView> createState() => _ResponsiveRowShowcaseViewState();
}

class _ResponsiveRowShowcaseViewState extends State<ResponsiveRowShowcaseView> {
  // Case B — adjustable spacing
  double _spacing = 12;

  // Case F — adjustable itemCount
  int _itemCount = 4;

  // Case G — form state
  String _firstName = '';
  String _lastName = '';

  // Case H — crossAxisAlignment
  CrossAxisAlignment _alignment = CrossAxisAlignment.start;

  // ── Case A ─────────────────────────────────────────────────────────────
  Widget _caseA() {
    return ResponsiveRow(
      spacing: 12,
      children: [
        ResponsiveCol(
          xs: .col12,
          md: .col6,
          child: _DemoBox(color: Colors.blue, label: 'col6'),
        ),
        ResponsiveCol(
          xs: .col12,
          md: .col6,
          child: _DemoBox(color: Colors.orange, label: 'col6'),
        ),
      ],
    );
  }

  // ── Case B ─────────────────────────────────────────────────────────────
  Widget _caseB() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('spacing: ${_spacing.toStringAsFixed(1)} px'),
        Slider(
          value: _spacing,
          min: 0,
          max: 32,
          divisions: 32,
          label: _spacing.toStringAsFixed(0),
          onChanged: (v) => setState(() => _spacing = v),
        ),
        ResponsiveRow(
          spacing: _spacing,
          children: [
            ResponsiveCol(
              xs: .col12,
              sm: .col4,
              child: _DemoBox(color: Colors.green, label: 'col4'),
            ),
            ResponsiveCol(
              xs: .col12,
              sm: .col4,
              child: _DemoBox(color: Colors.teal, label: 'col4'),
            ),
            ResponsiveCol(
              xs: .col12,
              sm: .col4,
              child: _DemoBox(color: Colors.cyan, label: 'col4'),
            ),
          ],
        ),
      ],
    );
  }

  // ── Case C ─────────────────────────────────────────────────────────────
  Widget _caseC() {
    return ResponsiveRow(
      spacing: 8,
      children: [
        ResponsiveCol(
          xs: .col12,
          md: .col6,
          child: _DemoBox(color: Colors.purple, label: 'col6 (row 1)'),
        ),
        ResponsiveCol(
          xs: .col12,
          md: .col6,
          child: _DemoBox(color: Colors.deepPurple, label: 'col6 (row 1)'),
        ),
        ResponsiveCol(
          xs: .col12,
          md: .col4,
          child: _DemoBox(color: Colors.pink, label: 'col4 (row 2)'),
        ),
        ResponsiveCol(
          xs: .col12,
          md: .col4,
          child: _DemoBox(color: Colors.red, label: 'col4 (row 2)'),
        ),
        ResponsiveCol(
          xs: .col12,
          md: .col4,
          child: _DemoBox(color: Colors.deepOrange, label: 'col4 (row 2)'),
        ),
      ],
    );
  }

  // ── Case D ─────────────────────────────────────────────────────────────
  Widget _caseD() {
    final colors = [Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan];
    return ResponsiveRow(
      spacing: 8,
      children: [
        for (final c in colors)
          ResponsiveCol(
            xs: .col12,
            sm: .col6,
            md: .col4,
            lg: .col3,
            child: _DemoBox(color: c, label: 'xs=12 sm=6 md=4 lg=3'),
          ),
      ],
    );
  }

  // ── Case E ─────────────────────────────────────────────────────────────
  Widget _caseE() {
    return ResponsiveRow(
      spacing: 20,
      children: [
        ResponsiveCol(
          xs: .col12,
          child: _DemoBox(color: Colors.amber, label: 'col12 (item 1)'),
        ),
        ResponsiveCol(
          xs: .col12,
          child: _DemoBox(color: Colors.orange, label: 'col12 (item 2)'),
        ),
        ResponsiveCol(
          xs: .col12,
          child: _DemoBox(color: Colors.deepOrange, label: 'col12 (item 3)'),
        ),
      ],
    );
  }

  // ── Case F ─────────────────────────────────────────────────────────────
  Widget _caseF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ThemedNumberInput(
          labelText: 'itemCount',
          value: _itemCount,
          minimum: 1,
          maximum: 6,
          step: 1,
          maximumDecimalDigits: 0,
          onChanged: (v) => setState(() => _itemCount = (v ?? 1).toInt().clamp(1, 6)),
        ),
        const SizedBox(height: 12),
        ResponsiveRow.builder(
          spacing: 8,
          itemCount: _itemCount,
          itemBuilder: (index) => ResponsiveCol(
            xs: .col12,
            sm: .col6,
            md: .col4,
            child: _DemoBox(
              color: Colors.primaries[index % Colors.primaries.length],
              label: 'Item ${index + 1}',
            ),
          ),
        ),
      ],
    );
  }

  // ── Case G ─────────────────────────────────────────────────────────────
  Widget _caseG() {
    return ResponsiveRow(
      spacing: 12,
      children: [
        ResponsiveCol(
          xs: .col12,
          md: .col6,
          child: ThemedTextInput(
            labelText: 'First name',
            value: _firstName,
            onChanged: (v) => setState(() => _firstName = v),
          ),
        ),
        ResponsiveCol(
          xs: .col12,
          md: .col6,
          child: ThemedTextInput(
            labelText: 'Last name',
            value: _lastName,
            onChanged: (v) => setState(() => _lastName = v),
          ),
        ),
      ],
    );
  }

  // ── Case H ─────────────────────────────────────────────────────────────
  Widget _caseH() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<CrossAxisAlignment>(
          value: _alignment,
          items: const [
            DropdownMenuItem(value: CrossAxisAlignment.start, child: Text('CrossAxisAlignment.start')),
            DropdownMenuItem(value: CrossAxisAlignment.center, child: Text('CrossAxisAlignment.center')),
            DropdownMenuItem(value: CrossAxisAlignment.end, child: Text('CrossAxisAlignment.end')),
          ],
          onChanged: (v) => setState(() => _alignment = v ?? CrossAxisAlignment.start),
        ),
        const SizedBox(height: 8),
        ResponsiveRow(
          spacing: 8,
          crossAxisAlignment: _alignment == CrossAxisAlignment.start
              ? WrapCrossAlignment.start
              : _alignment == CrossAxisAlignment.center
                  ? WrapCrossAlignment.center
                  : WrapCrossAlignment.end,
          children: [
            ResponsiveCol(
              xs: .col12,
              sm: .col4,
              child: _DemoBox(color: Colors.red, label: 'h=80', height: 80),
            ),
            ResponsiveCol(
              xs: .col12,
              sm: .col4,
              child: _DemoBox(color: Colors.green, label: 'h=130', height: 130),
            ),
            ResponsiveCol(
              xs: .col12,
              sm: .col4,
              child: _DemoBox(color: Colors.blue, label: 'h=100', height: 100),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Responsive Grid',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                _SectionCard(
                  title: 'Case A: 2× col6 with spacing > 0',
                  caption: 'Two half-width columns with a 12 px true gap — at md+ they appear side-by-side.',
                  demo: _caseA(),
                  code: r'''
ResponsiveRow(
  spacing: 12,
  children: [
    ResponsiveCol(xs: .col12, md: .col6, child: WidgetA()),
    ResponsiveCol(xs: .col12, md: .col6, child: WidgetB()),
  ],
)''',
                ),
                _SectionCard(
                  title: 'Case B: 3× col4 with tunable spacing',
                  caption: 'Drag the slider to see how a TRUE gap shrinks each column width proportionally.',
                  demo: _caseB(),
                  code: r'''
ResponsiveRow(
  spacing: spacing,  // double, 0–32
  children: [
    ResponsiveCol(xs: .col12, sm: .col4, child: WidgetA()),
    ResponsiveCol(xs: .col12, sm: .col4, child: WidgetB()),
    ResponsiveCol(xs: .col12, sm: .col4, child: WidgetC()),
  ],
)''',
                ),
                _SectionCard(
                  title: 'Case C: Mixed grid (col6+col6 / col4+col4+col4)',
                  caption: 'Five children grouped into two visual rows at md+: first two share a row (col6), then three share the next (col4).',
                  demo: _caseC(),
                  code: r'''
ResponsiveRow(
  spacing: 8,
  children: [
    ResponsiveCol(xs: .col12, md: .col6, child: WidgetA()),  // row 1
    ResponsiveCol(xs: .col12, md: .col6, child: WidgetB()),  // row 1
    ResponsiveCol(xs: .col12, md: .col4, child: WidgetC()),  // row 2
    ResponsiveCol(xs: .col12, md: .col4, child: WidgetD()),  // row 2
    ResponsiveCol(xs: .col12, md: .col4, child: WidgetE()),  // row 2
  ],
)''',
                ),
                _SectionCard(
                  title: 'Case D: Fully responsive breakpoint reflow',
                  caption: 'xs=1 col, sm=2 cols, md=3 cols, lg=4 cols — resize the window to see the grid reflow.',
                  demo: _caseD(),
                  code: r'''
ResponsiveRow(
  spacing: 8,
  children: [
    for (final item in items)
      ResponsiveCol(
        xs: .col12,  // 1 column on mobile
        sm: .col6,   // 2 columns on small screens
        md: .col4,   // 3 columns on medium screens
        lg: .col3,   // 4 columns on large screens
        child: ItemWidget(item),
      ),
  ],
)''',
                ),
                _SectionCard(
                  title: 'Case E: Stacked col12 with vertical gap',
                  caption: 'Three full-width rows with spacing: 20 — vertical SizedBox(height: 20) is inserted between each row.',
                  demo: _caseE(),
                  code: r'''
ResponsiveRow(
  spacing: 20,
  children: [
    ResponsiveCol(xs: .col12, child: WidgetA()),
    ResponsiveCol(xs: .col12, child: WidgetB()),
    ResponsiveCol(xs: .col12, child: WidgetC()),
  ],
)''',
                ),
                _SectionCard(
                  title: 'Case F: ResponsiveRow.builder with dynamic itemCount',
                  caption: 'Use the .builder constructor to generate cols from a list. Use the ThemedNumberInput to change the count (1–6).',
                  demo: _caseF(),
                  code: r'''
ResponsiveRow.builder(
  spacing: 8,
  itemCount: itemCount,  // 1..6
  itemBuilder: (index) => ResponsiveCol(
    xs: .col12,
    sm: .col6,
    md: .col4,
    child: ItemCard(items[index]),
  ),
)''',
                ),
                _SectionCard(
                  title: 'Case G: Responsive form layout',
                  caption: 'Two form fields side-by-side at md+, stacked on mobile. The classic two-column form pattern.',
                  demo: _caseG(),
                  code: r'''
ResponsiveRow(
  spacing: 12,
  children: [
    ResponsiveCol(
      xs: .col12,
      md: .col6,
      child: ThemedTextInput(
        labelText: 'First name',
        value: firstName,
        onChanged: (v) => setState(() => firstName = v),
      ),
    ),
    ResponsiveCol(
      xs: .col12,
      md: .col6,
      child: ThemedTextInput(
        labelText: 'Last name',
        value: lastName,
        onChanged: (v) => setState(() => lastName = v),
      ),
    ),
  ],
)''',
                ),
                _SectionCard(
                  title: 'Case H: crossAxisAlignment with mixed-height children',
                  caption: 'Use the dropdown to toggle start / center / end alignment of columns with different heights.',
                  demo: _caseH(),
                  code: r'''
ResponsiveRow(
  spacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,  // .start | .center | .end
  children: [
    ResponsiveCol(xs: .col12, sm: .col4, child: SizedBox(height: 80,  child: ColorBox())),
    ResponsiveCol(xs: .col12, sm: .col4, child: SizedBox(height: 130, child: ColorBox())),
    ResponsiveCol(xs: .col12, sm: .col4, child: SizedBox(height: 100, child: ColorBox())),
  ],
)''',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private helpers ─────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final String caption;
  final Widget demo;
  final String code;

  const _SectionCard({
    required this.title,
    required this.caption,
    required this.demo,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(caption, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            demo,
            const SizedBox(height: 12),
            _CodeBlock(code: code),
          ],
        ),
      ),
    );
  }
}

class _DemoBox extends StatelessWidget {
  final Color color;
  final String label;
  final double height;

  const _DemoBox({
    required this.color,
    required this.label,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;

  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
      ),
      child: SelectableText(
        code.trim(),
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
    );
  }
}
