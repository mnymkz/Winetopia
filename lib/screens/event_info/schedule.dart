import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            color: const Color(0xCC761973),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: const Text('Session 1: FRIDAY 5PM - 8.45PM',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              //subtitle: Text('Trailing expansion arrow icon'),
              children: <Widget>[
                //ListTile(title: Text('This is tile number 1')),
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  color: const Color(0xFFE4B9E3),
                  child: ExpansionTile(
                    title: const Text('MAIN STAGE',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('HOSTED BY KEELAN MCCAFFERTY'),
                    children: [
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          tileColor: Colors.white,
                          title: Text('5.30PM'),
                          subtitle: Text(
                              'Winetopia Dream Room with Mike Bennie & Violeta Santis, Cloudy Bay Assistant Winemaker'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('6.10PM'),
                          subtitle: Text(
                              'Share A Glass with Michael Hurst, Award Winning Actor & Director'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('6.50PM'),
                          subtitle: Text(
                              'M Wine Destinations with Mike Bennie - France & NZ, sponsored by YOU Travel & Cruise'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('7.30PM'),
                          subtitle: Text(
                              'Where the Wild Things Are \nWine Battle: Marlborough vs Hawke’s Bay'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('8.00PM'),
                          subtitle: Text('Live Music by The Tiny Tickets'),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 15),
                  color: const Color(0xFFE4B9E3),
                  child: ExpansionTile(
                    title: const Text('AMERICAN EXPRESS PREMIUM LOUNGE',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('HOSTED BY MERMAID MARY'),
                    children: [
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('6.00PM'),
                          subtitle: Text('Discover Fromm'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('7.00PM'),
                          subtitle: Text('Discover Mt Rosa'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('8.00PM'),
                          subtitle: Text('Discover Rockburn'),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 15),
                  color: const Color(0xFFE4B9E3),
                  child: ExpansionTile(
                    title: const Text('MASTERCLASSES',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    //subtitle: Text('EXPERT-LED MASTERCLASSES RUN FOR 30 - 40 MINUTES TASTING 4 PREMIUM WINES. LOCATED ON LEVEL 3.'),
                    children: [
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('6.30 - 7.10PM'),
                          subtitle: Text('Wine & Food Pairing with Duo Eatery'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('7.30 - 8.00PM'),
                          subtitle: Text('Great Whites, Decadent Reds'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            color: const Color(0xCC761973),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: const Text('Session 2: SATURDAY 12PM - 3.30PM',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              //subtitle: Text('Trailing expansion arrow icon'),
              children: <Widget>[
                //ListTile(title: Text('This is tile number 1')),
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  color: const Color(0xFFE4B9E3),
                  child: ExpansionTile(
                    title: const Text('MAIN STAGE',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('HOSTED BY KEELAN MCCAFFERTY'),
                    children: [
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('12.20PM'),
                          subtitle: Text(
                              'Breakfast of Champions with Mike Bennie:\nCrisp, fruity, refreshing'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('12.55PM'),
                          subtitle: Text(
                              'Share A Glass with Kasey & Kārena Bird, MasterChef NZ Winners & Authors'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('1.30PM'),
                          subtitle: Text(
                              'Rice vs Grapes Wine Battle: Japan vs Marlborough'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('2.15PM'),
                          subtitle: Text(
                              'Wine Destinations with Mike Bennie - Italian & NZ, sponsored by YOU Travel & Cruise '),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('2.45PM'),
                          subtitle: Text('Live Music by The Tiny Tickets'),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 15),
                  color: const Color(0xFFE4B9E3),
                  child: ExpansionTile(
                    title: const Text('AMERICAN EXPRESS PREMIUM LOUNGE',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('HOSTED BY MERMAID MARY'),
                    children: [
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('12.30PM'),
                          subtitle: Text('Discover No 1 Family Estate'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('1.30PM'),
                          subtitle: Text('Discover Clos Henri'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('2.30PM'),
                          subtitle: Text('Discover Wooing Tree'),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 15),
                  color: const Color(0xFFE4B9E3),
                  child: ExpansionTile(
                    title: const Text('MASTERCLASSES',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    //subtitle: Text('EXPERT-LED MASTERCLASSES RUN FOR 30 - 40 MINUTES TASTING 4 PREMIUM WINES. LOCATED ON LEVEL 3.'),
                    children: [
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('11.45 - 12.25PM'),
                          subtitle: Text('Wine & Food Pairing with Culprit'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('12.45 - 1.15PM'),
                          subtitle:
                              Text('Dream Room Masterclass with Mike Bennie'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('1.35 - 2.05PM'),
                          subtitle: Text(
                              'Let’s get Fizzed - Top NZ Methode with Angela Allan'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('2:25 - 3.05PM'),
                          subtitle: Text('Wine & Food Pairing with Manzo'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            color: const Color(0xCC761973),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: const Text(
                'Session 3: SATURDAY 5PM - 8.30PM',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              //subtitle: Text('Trailing expansion arrow icon'),
              children: <Widget>[
                //ListTile(title: Text('This is tile number 1')),
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  color: const Color(0xFFE4B9E3),
                  child: ExpansionTile(
                    title: const Text('MAIN STAGE',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('HOSTED BY KEELAN MCCAFFERTY'),
                    children: [
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('5.15PM'),
                          subtitle: Text('Tickle Me Pink with Mike Bennie'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('5.50PM'),
                          subtitle: Text(
                              'M Share A Glass with Matt Heath, Broadcaster & Author of “A Life Less Punishing”'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('6.25PM'),
                          subtitle: Text(
                              'Pinot vs Pinot Wine Battle: Marlborough vs Central Otago'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('7.00PM'),
                          subtitle: Text(
                              'M Winetopia Dream Room with Mike Bennie & Jordyn Harper, Winemaker of Craggy Range'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('7.35PM'),
                          subtitle: Text('Live Music by The Tiny Tickets'),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 15),
                  color: const Color(0xFFE4B9E3),
                  child: ExpansionTile(
                    title: const Text('AMERICAN EXPRESS PREMIUM LOUNGE',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('HOSTED BY MERMAID MARY'),
                    children: [
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('6.00PM'),
                          subtitle: Text('Discover Cloudy Bay'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('6.45PM'),
                          subtitle: Text('Discover Esses'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('7.30PM'),
                          subtitle: Text('Discover Moy Hall'),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 15),
                  color: const Color(0xFFE4B9E3),
                  child: ExpansionTile(
                    title: const Text('MASTERCLASSES',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    //subtitle: Text('EXPERT-LED MASTERCLASSES RUN FOR 30 - 40 MINUTES TASTING 4 PREMIUM WINES. LOCATED ON LEVEL 3.'),
                    children: [
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('4.45 - 5.25PM'),
                          subtitle: Text('Wine & Food Pairing with Te Kaahu'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('5.45 - 6.15PM'),
                          subtitle: Text(
                              'Round the World in Rouge - Top Reds with Mike Bennie'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('6.35 - 7.05PM'),
                          subtitle: Text(
                              'The Great Kiwi (Wine) Roadtrip with Cameron Douglas MS'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: const ListTile(
                          title: Text('7.25 - 8.05PM'),
                          subtitle: Text('Wine & Food Pairing with Bossi'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
