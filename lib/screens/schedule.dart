import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child:  Column(
        children: <Widget>[
          ExpansionTile(
            title: Text('Session 1: FRIDAY 5PM - 8.45PM'),
            //subtitle: Text('Trailing expansion arrow icon'),
            children: <Widget>[
              //ListTile(title: Text('This is tile number 1')),
              ExpansionTile(
                title: Text('MAIN STAGE'),
                subtitle: Text('HOSTED BY KEELAN MCCAFFERTY'),
                children: [
                  ListTile(
                    title: Text('5.30PM'),
                    subtitle: Text('Winetopia Dream Room with Mike Bennie & Violeta Santis, Cloudy Bay Assistant Winemaker'),
                  ),
                  ListTile(
                    title: Text('6.10PM'),
                    subtitle: Text('Share A Glass with Michael Hurst, Award Winning Actor & Director'),
                  ),
                  ListTile(
                    title: Text('6.50PM'),
                    subtitle: Text('M Wine Destinations with Mike Bennie - France & NZ, sponsored by YOU Travel & Cruise'),
                  ),
                  ListTile(
                    title: Text('7.30PM'),
                    subtitle: Text('Where the Wild Things Are \nWine Battle: Marlborough vs Hawke’s Bay'),
                  ),
                  ListTile(
                    title: Text('8.00PM'),
                    subtitle: Text('Live Music by The Tiny Tickets'),
                  ),
                ],
              ),
      
              ExpansionTile(
                title: Text('AMERICAN EXPRESS PREMIUM LOUNGE'),
                subtitle: Text('HOSTED BY MERMAID MARY'),
                children: [
                  ListTile(
                    title: Text('6.00PM'),
                    subtitle: Text('Discover Fromm'),
                  ),
                  ListTile(
                    title: Text('7.00PM'),
                    subtitle: Text('Discover Mt Rosa'),
                  ),
                  ListTile(
                    title: Text('8.00PM'),
                    subtitle: Text('Discover Rockburn'),
                  ),
                ],
              ),
      
              ExpansionTile(
                title: Text('MASTERCLASSES'),
                //subtitle: Text('EXPERT-LED MASTERCLASSES RUN FOR 30 - 40 MINUTES TASTING 4 PREMIUM WINES. LOCATED ON LEVEL 3.'),
                children: [
                  ListTile(
                    title: Text('6.30 - 7.10PM'),
                    subtitle: Text('Wine & Food Pairing with Duo Eatery'),
                  ),
                  ListTile(
                    title: Text('7.30 - 8.00PM'),
                    subtitle: Text('Great Whites, Decadent Reds'),
                  ),
                ],
              )
            ],
          ),
      
          ExpansionTile(
            title: Text('Session 2: SATURDAY 12PM - 3.30PM'),
            //subtitle: Text('Trailing expansion arrow icon'),
            children: <Widget>[
              //ListTile(title: Text('This is tile number 1')),
              ExpansionTile(
                title: Text('MAIN STAGE'),
                subtitle: Text('HOSTED BY KEELAN MCCAFFERTY'),
                children: [
                  ListTile(
                    title: Text('12.20PM'),
                    subtitle: Text('Breakfast of Champions with Mike Bennie:\nCrisp, fruity, refreshing'),
                  ),
                  ListTile(
                    title: Text('12.55PM'),
                    subtitle: Text('Share A Glass with Kasey & Kārena Bird, MasterChef NZ Winners & Authors'),
                  ),
                  ListTile(
                    title: Text('1.30PM'),
                    subtitle: Text('Rice vs Grapes Wine Battle: Japan vs Marlborough'),
                  ),
                  ListTile(
                    title: Text('2.15PM'),
                    subtitle: Text('Wine Destinations with Mike Bennie - Italian & NZ, sponsored by YOU Travel & Cruise '),
                  ),
                  ListTile(
                    title: Text('2.45PM'),
                    subtitle: Text('Live Music by The Tiny Tickets'),
                  ),
                ],
              ),
      
              ExpansionTile(
                title: Text('AMERICAN EXPRESS PREMIUM LOUNGE'),
                subtitle: Text('HOSTED BY MERMAID MARY'),
                children: [
                  ListTile(
                    title: Text('12.30PM'),
                    subtitle: Text('Discover No 1 Family Estate'),
                  ),
                  ListTile(
                    title: Text('1.30PM'),
                    subtitle: Text('Discover Clos Henri'),
                  ),
                  ListTile(
                    title: Text('2.30PM'),
                    subtitle: Text('Discover Wooing Tree'),
                  ),
                ],
              ),
      
              ExpansionTile(
                title: Text('MASTERCLASSES'),
                //subtitle: Text('EXPERT-LED MASTERCLASSES RUN FOR 30 - 40 MINUTES TASTING 4 PREMIUM WINES. LOCATED ON LEVEL 3.'),
                children: [
                  ListTile(
                    title: Text('11.45 - 12.25PM'),
                    subtitle: Text('Wine & Food Pairing with Culprit'),
                  ),
                  ListTile(
                    title: Text('12.45 - 1.15PM'),
                    subtitle: Text('Dream Room Masterclass with Mike Bennie'),
                  ),
                  ListTile(
                    title: Text('1.35 - 2.05PM'),
                    subtitle: Text('Let’s get Fizzed - Top NZ Methode with Angela Allan'),
                  ),
                  ListTile(
                    title: Text('2:25 - 3.05PM'),
                    subtitle: Text('Wine & Food Pairing with Manzo'),
                  ),
                ],
              )
            ],
          ),
      
          ExpansionTile(
            title: Text('Session 3: SATURDAY 5PM - 8.30PM'),
            //subtitle: Text('Trailing expansion arrow icon'),
            children: <Widget>[
              //ListTile(title: Text('This is tile number 1')),
              ExpansionTile(
                title: Text('MAIN STAGE'),
                subtitle: Text('HOSTED BY KEELAN MCCAFFERTY'),
                children: [
                  ListTile(
                    title: Text('5.15PM'),
                    subtitle: Text('Tickle Me Pink with Mike Bennie'),
                  ),
                  ListTile(
                    title: Text('5.50PM'),
                    subtitle: Text('M Share A Glass with Matt Heath, Broadcaster & Author of “A Life Less Punishing”'),
                  ),
                  ListTile(
                    title: Text('6.25PM'),
                    subtitle: Text('Pinot vs Pinot Wine Battle: Marlborough vs Central Otago'),
                  ),
                  ListTile(
                    title: Text('7.00PM'),
                    subtitle: Text('M Winetopia Dream Room with Mike Bennie & Jordyn Harper, Winemaker of Craggy Range'),
                  ),
                  ListTile(
                    title: Text('7.35PM'),
                    subtitle: Text('Live Music by The Tiny Tickets'),
                  ),
                ],
              ),
      
              ExpansionTile(
                title: Text('AMERICAN EXPRESS PREMIUM LOUNGE'),
                subtitle: Text('HOSTED BY MERMAID MARY'),
                children: [
                  ListTile(
                    title: Text('6.00PM'),
                    subtitle: Text('Discover Cloudy Bay'),
                  ),
                  ListTile(
                    title: Text('6.45PM'),
                    subtitle: Text('Discover Esses'),
                  ),
                  ListTile(
                    title: Text('7.30PM'),
                    subtitle: Text('Discover Moy Hall'),
                  ),
                ],
              ),
      
              ExpansionTile(
                title: Text('MASTERCLASSES'),
                //subtitle: Text('EXPERT-LED MASTERCLASSES RUN FOR 30 - 40 MINUTES TASTING 4 PREMIUM WINES. LOCATED ON LEVEL 3.'),
                children: [
                  ListTile(
                    title: Text('4.45 - 5.25PM'),
                    subtitle: Text('Wine & Food Pairing with Te Kaahu'),
                  ),
                  ListTile(
                    title: Text('5.45 - 6.15PM'),
                    subtitle: Text('Round the World in Rouge - Top Reds with Mike Bennie'),
                  ),
                  ListTile(
                    title: Text('6.35 - 7.05PM'),
                    subtitle: Text('The Great Kiwi (Wine) Roadtrip with Cameron Douglas MS'),
                  ),
                  ListTile(
                    title: Text('7.25 - 8.05PM'),
                    subtitle: Text('Wine & Food Pairing with Bossi'),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}