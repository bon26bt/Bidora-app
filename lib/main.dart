import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const BidoraApp());
}

class BidoraApp extends StatefulWidget {
  const BidoraApp({Key? key}) : super(key: key);

  @override
  State<BidoraApp> createState() => _BidoraAppState();
}

class _BidoraAppState extends State<BidoraApp> {
  String _selectedLang = 'EN'; // Options: EN, AM, OM

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bidora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF7F2),
        primaryColor: const Color(0xFFC05621),
        fontFamily: 'sans-serif',
      ),
      home: BidoraHomeScreen(
        lang: _selectedLang,
        onLangChanged: (newLang) {
          setState(() {
            _selectedLang = newLang;
          });
        },
      ),
    );
  }
}

class BidoraHomeScreen extends StatefulWidget {
  final String lang;
  final Function(String) onLangChanged;

  const BidoraHomeScreen({
    Key? key,
    required this.lang,
    required this.onLangChanged,
  }) : super(key: key);

  @override
  State<BidoraHomeScreen> createState() => _BidoraHomeScreenState();
}

class _BidoraHomeScreenState extends State<BidoraHomeScreen> {
  int _currentIndex = 0;
  List<String> _debugLogs = [];

  // Translations
  Map<String, Map<String, String>> texts = {
    'EN': {
      'headerTitle': 'Bidora',
      'bannerTag': '4 LIVE AUCTIONS',
      'bannerTitle': 'The rarest number wins.',
      'bannerSub': 'Choose low. Stay unique. Each auction lists its own entry fee.',
      'bannerBtn': 'Enter the auction floor',
      'strategyTitle': 'Three moves to win',
      'step1Title': 'Pick a number',
      'step1Desc': 'Start at the minimum and choose an amount you think nobody else will use.',
      'step2Title': 'Pay the entry',
      'step2Desc': 'Approve the entry fee in Telebirr or CBE Birr. Your number only enters once payment clears.',
      'step3Title': 'Stay unique',
      'step3Desc': 'If another bidder matches you, both bids leave the running. Lowest unique wins.',
      'archiveTitle': 'Recently claimed',
      'winningAmount': 'Winning amount - 5.32 ETB',
      'home': 'Home',
      'explore': 'Explore',
      'bids': 'My bids',
      'profile': 'Profile',
    },
    'OM': {
      'headerTitle': 'Bidora',
      'bannerTag': '4 MORKII JIRAN',
      'bannerTitle': 'Lakkoofsa addaa ta\'etuu injifata.',
      'bannerSub': 'Xiqqaa filadhu. Adda ta\'i. Morkiin ka\'umsa kaffaltii qaba.',
      'bannerBtn': 'Morkiitti seeni',
      'strategyTitle': 'Tarkaanfiiwwan injifannoo 3',
      'step1Title': 'Lakkoofsa filadhu',
      'step1Desc': 'Gatiidhaan jalqabiiti lakkoofsa namni biraa hin filanne tilmaami.',
      'step2Title': 'Kaffaltii kaffali',
      'step2Desc': 'Telebirr ykn CBE Birr \'n kaffaltii mirkaneessi. Payment kaffalamee galmaa\'a.',
      'step3Title': 'Adda ta\'i',
      'step3Desc': 'Namni biraa lakkoofsa kee filannaan, morkii irraa baatu. Lakkoofsi xiqqaan injifata.',
      'archiveTitle': 'Dhiyoo kan fudhatame',
      'winningAmount': 'Gatii injifatame - 5.32 ETB',
      'home': 'Maldha',
      'explore': 'Barbaadi',
      'bids': 'Morkii koo',
      'profile': 'Eenyummaa',
    },
    'AM': {
      'headerTitle': 'Bidora',
      'bannerTag': '4 በቀጥታ ጨረታዎች',
      'bannerTitle': 'አነስተኛ እና ልዩ የሆነ ቁጥር ያሸንፋል።',
      'bannerSub': 'ዝቅተኛ ይምረጡ። ልዩ ይሁኑ። እያንዳንዱ ጨረታ የራሱ መግቢያ ክፍያ አለው።',
      'bannerBtn': 'ወደ ጨረታው ይግቡ',
      'strategyTitle': 'የማሸነፊያ 3 ደረጃዎች',
      'step1Title': 'ቁጥር ይምረጡ',
      'step1Desc': 'ከዝቅተኛው ጀምረው ማንም አይመርጠውም ብለው ያሰቡትን ያህል ይምረጡ።',
      'step2Title': 'መግቢያውን ይክፈሉ',
      'step2Desc': 'በቴሌብር (Telebirr) ወይም በCBE Birr ክፍያውን ያረጋግጡ።',
      'step3Title': 'ልዩ ይሁኑ',
      'step3Desc': 'ሌላ ተጫራች ከእርስዎ ጋር ከተመሳሰለ ሁለቱም ይወጣሉ። አነስተኛ እና ልዩ ያሸንፋል።',
      'archiveTitle': 'በቅርቡ የተወሰዱ',
      'winningAmount': 'የማሸነፊያ ዋጋ - 5.32 ETB',
      'home': 'መነሻ',
      'explore': 'ያግኙ',
      'bids': 'የእኔ ጨረታ',
      'profile': 'መገለጫ',
    }
  };

  void _showFCMDebugLog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FCM debug log',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'serif'),
                  ),
                  const SizedBox(height: 10),
                  const Text('Storage: public Documents/Bidora', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const Text('Path: Documents/Bidora/bidora_fcm_debug.log', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 15),
                  Container(
                    height: 120,
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EFEA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        _debugLogs.isEmpty
                            ? '(no FCM debug log yet - tap "Write test line", then check again)'
                            : _debugLogs.join('\n'),
                        style: TextStyle(fontSize: 12, color: _debugLogs.isEmpty ? Colors.grey : Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _debugLogs.add('[${DateTime.now().toIso8601String().substring(11, 19)}] FCM Test Ping: Token verified. Service active.');
                            });
                          },
                          child: const Text('Write test line', style: TextStyle(color: Color(0xFFC05621))),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _debugLogs.clear();
                            });
                          },
                          child: const Text('Clear', style: TextStyle(color: Color(0xFFC05621))),
                        ),
                        TextButton(
                          onPressed: () {
                            if (_debugLogs.isNotEmpty) {
                              Clipboard.setData(ClipboardData(text: _debugLogs.join('\n')));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard!')));
                            }
                          },
                          child: const Text('Copy', style: TextStyle(color: Color(0xFFC05621))),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var t = texts[widget.lang]!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF7F2),
        elevation: 0,
        title: Text(
          t['headerTitle']!,
          style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'serif'),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: widget.lang,
              items: const [
                DropdownMenuItem(value: 'EN', child: Text('🌐 EN')),
                DropdownMenuItem(value: 'OM', child: Text('🌐 OM')),
                DropdownMenuItem(value: 'AM', child: Text('🌐 አማ')),
              ],
              onChanged: (val) {
                if (val != null) widget.onLangChanged(val);
              },
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report_outlined, color: Colors.black),
            onPressed: _showFCMDebugLog,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Live Auction Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1C1A),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(t['bannerTag']!, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t['bannerTitle']!,
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'serif'),
                  ),
                  const SizedBox(height: 8),
                  Text(t['bannerSub']!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD69E2E),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {},
                    child: Text('↗ ${t['bannerBtn']}'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Simple Strategy Section
            Text('SIMPLE STRATEGY', style: TextStyle(color: Colors.brown[400], fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(t['strategyTitle']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'serif')),
            const SizedBox(height: 16),

            _buildStep('01', t['step1Title']!, t['step1Desc']!, isPrimary: true),
            _buildStep('02', t['step2Title']!, t['step2Desc']!),
            _buildStep('03', t['step3Title']!, t['step3Desc']!),

            const SizedBox(height: 24),

            // Recently Claimed Section
            Text('THE ARCHIVE', style: TextStyle(color: Colors.brown[400], fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(t['archiveTitle']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'serif')),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.phone_iphone, color: Colors.orange, size: 36),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('iPhone 17 Pro Max', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(t['winningAmount']!, style: const TextStyle(color: Colors.teal, fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 3) {
            _showFCMDebugLog();
          }
        },
        selectedItemColor: const Color(0xFFC05621),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: t['home']),
          BottomNavigationBarItem(icon: const Icon(Icons.grid_view), label: t['explore']),
          BottomNavigationBarItem(icon: const Icon(Icons.star_outline), label: t['bids']),
          BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: t['profile']),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String title, String desc, {bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: isPrimary ? const Color(0xFFC05621) : Colors.white,
            foregroundColor: isPrimary ? Colors.white : Colors.black,
            radius: 18,
            child: Text(number, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Colors.black87, fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
