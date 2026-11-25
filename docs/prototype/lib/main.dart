import 'dart:convert';

import 'package:flutter/material.dart';

import 'store.dart' if (dart.library.html) 'browser_store.dart' as store;

const ink = Color(0xff18283a);
const blue = Color(0xff24568a);
const paper = Color(0xfff9faf5);
const mist = Color(0xffe2ebed);
const gold = Color(0xffffcb73);
const guestRoute = '/reviews/lighthouse';
const statuses = ['Без отметки', 'До титров', 'Ещё играю', 'Отложил'];

String scoreLabel(int units) =>
    units.isEven ? '${units ~/ 2}' : '${units ~/ 2},5';

void main() => runApp(const Prototype());

class Prototype extends StatelessWidget {
  const Prototype({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaveMargin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: paper,
        colorScheme: ColorScheme.fromSeed(seedColor: blue, primary: blue),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      routes: {
        '/': (_) => const Editor(),
        guestRoute: (_) => const GuestPage(),
      },
    );
  }
}

class Frame extends StatelessWidget {
  const Frame(this.content, {super.key, this.phone = false});
  final Widget content;
  final bool phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: phone ? 410 : 880),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'SaveMargin',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      color: ink,
                      padding: const EdgeInsets.all(22),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Приключение / PC',
                            style: TextStyle(color: gold),
                          ),
                          Text(
                            'Последний маяк',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 38,
                              color: paper,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    content,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Editor extends StatefulWidget {
  const Editor({super.key});
  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final note = TextEditingController();
  final strip = ScrollController();
  int minutes = 89;
  int units = 10;
  bool phone = true;
  bool spoiler = false;
  String status = statuses.first;
  String feedback = '';

  @override
  void initState() {
    super.initState();
    minutes = int.tryParse(store.read('minutes') ?? '') ?? 89;
    phone = minutes < 90;
    final published = store.read('review');
    if (published != null) {
      final review = jsonDecode(published) as Map<String, dynamic>;
      units = review['units'];
      note.text = review['text'];
      status = review['status'];
      spoiler = review['spoiler'];
    }
    note.text = store.read('draft') ?? note.text;
  }

  @override
  void dispose() {
    note.dispose();
    strip.dispose();
    super.dispose();
  }

  void saveDraft() {
    store.write('draft', note.text);
    setState(() => feedback = 'Черновик сохранён. Его видишь только ты.');
  }

  void sync() {
    store.write('minutes', '90');
    setState(() {
      minutes = 90;
      phone = false;
      feedback = 'В макете Steam подтвердил 90 минут.';
    });
  }

  void publish() {
    if (minutes < 90) return;
    store.write(
      'review',
      jsonEncode({
        'units': units,
        'minutes': minutes,
        'text': note.text.trim(),
        'status': status,
        'spoiler': spoiler,
      }),
    );
    store.remove('draft');
    setState(() => feedback = 'Рецензия опубликована.');
    Navigator.pushNamed(context, guestRoute);
  }

  @override
  Widget build(BuildContext context) {
    final eligible = minutes >= 90;
    return Frame(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Steam  ·  $minutes из 90 мин',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (!eligible)
                TextButton(onPressed: sync, child: const Text('Обновить часы')),
            ],
          ),
          LinearProgressIndicator(
            value: minutes / 90,
            minHeight: 5,
            color: blue,
            backgroundColor: mist,
          ),
          const SizedBox(height: 18),
          TextField(
            controller: note,
            minLines: 3,
            maxLines: 7,
            decoration: const InputDecoration(
              labelText: 'Мои впечатления',
              hintText: 'Что запомнилось в игре?',
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              onPressed: saveDraft,
              child: const Text('Сохранить черновик'),
            ),
          ),
          const Divider(height: 32),
          if (eligible) ...[
            Text(
              'Моя оценка   ${scoreLabel(units)} / 10',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Scrollbar(
              controller: strip,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: strip,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: List.generate(
                    21,
                    (i) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: ChoiceChip(
                        label: Text(scoreLabel(i)),
                        selected: i == units,
                        onSelected: (_) => setState(() => units = i),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            DropdownButton<String>(
              value: status,
              isExpanded: true,
              items: [
                for (final value in statuses)
                  DropdownMenuItem(value: value, child: Text(value)),
              ],
              onChanged: (value) => setState(() => status = value!),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('В тексте есть спойлеры'),
              value: spoiler,
              onChanged: (v) => setState(() => spoiler = v!),
            ),
          ] else
            const Text('Ещё 1 минута до оценки. Черновик уже доступен.'),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: eligible ? publish : null,
            child: const Text('Опубликовать'),
          ),
          if (feedback.isNotEmpty)
            Semantics(
              liveRegion: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(feedback),
              ),
            ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            children: [
              TextButton(
                onPressed: () => setState(() => phone = !phone),
                child: Text(
                  phone ? 'Макет для браузера' : 'Макет для телефона',
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, guestRoute),
                child: const Text('Вид гостя'),
              ),
            ],
          ),
        ],
      ),
      phone: phone,
    );
  }
}

class GuestPage extends StatefulWidget {
  const GuestPage({super.key});
  @override
  State<GuestPage> createState() => _GuestState();
}

class _GuestState extends State<GuestPage> {
  bool revealed = false;

  @override
  Widget build(BuildContext context) {
    final raw = store.read('review');
    if (raw == null)
      return const Frame(Text('Пока нет опубликованной рецензии.'));
    final review = jsonDecode(raw) as Map<String, dynamic>;
    return Frame(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Рецензия игрока Лис',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                scoreLabel(review['units']),
                style: const TextStyle(
                  fontSize: 60,
                  color: blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(' / 10'),
            ],
          ),
          Text("Steam · ${review['minutes']} мин на момент публикации"),
          if (review['status'] != statuses.first)
            Text("Отметка игрока · ${review['status']}"),
          const SizedBox(height: 16),
          if (review['spoiler'] && !revealed && review['text'] != '')
            OutlinedButton(
              onPressed: () => setState(() => revealed = true),
              child: const Text('Показать спойлер'),
            )
          else
            SelectableText(review['text']),
        ],
      ),
    );
  }
}
