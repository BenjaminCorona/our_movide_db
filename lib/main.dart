import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Movie {
  final String title;
  final String imageUrl;
  final String description;
  final int year;
  final double rating;

  Movie({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.year,
    required this.rating,
  });
}

class CustomPageScrollPhysics extends ScrollPhysics {
  const CustomPageScrollPhysics({ScrollPhysics? parent})
    : super(parent: parent);

  @override
  CustomPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring =>
      const SpringDescription(mass: 80, stiffness: 100, damping: 1);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;
  bool _imagesPrecached = false;

  final List<Movie> movies = [
    Movie(
      title: 'Interstellar',
      imageUrl:
          'https://image.tmdb.org/t/p/original/9cTfZWP5TfdnmAjiD6ZBXWIJ7O9.jpg',
      description: 'Una misión espacial para salvar a la humanidad.',
      year: 2014,
      rating: 8.6,
    ),
    Movie(
      title: 'Gravity',
      imageUrl:
          'https://image.tmdb.org/t/p/original/5r2dr9mUdb9jcS5V1BXQWcDnasu.jpg',
      description: 'Dos astronautas luchan por sobrevivir en el espacio.',
      year: 2013,
      rating: 7.7,
    ),
    Movie(
      title: 'Passengers',
      imageUrl:
          'https://image.tmdb.org/t/p/original/iLMtX4MGl8WjKCPfMgCdDuceOth.jpg',
      description:
          'Dos pasajeros de una nave espacial despertan antes de tiempo.',
      year: 2016,
      rating: 7.0,
    ),
    Movie(
      title: 'First Man',
      imageUrl:
          'https://image.tmdb.org/t/p/original/hLXDrsgBqdO0xJHoRlBBMMortWL.jpg',
      description:
          'La historia de Neil Armstrong, el primer hombre en la Luna.',
      year: 2018,
      rating: 7.3,
    ),
    Movie(
      title: 'The Martian',
      imageUrl:
          'https://image.tmdb.org/t/p/original/hBRK1izFxIH3Nh6vax4ssOHSHVd.jpg',
      description: 'Un astronauta lucha por sobrevivir en Marte.',
      year: 2015,
      rating: 8.0,
    ),
    Movie(
      title: 'Ad Astra',
      imageUrl:
          'https://image.tmdb.org/t/p/original/kK6Oq4JywUNXmJ299efUkv1h6Mn.jpg',
      description:
          'Un astronauta viaja al espacio profundo para encontrar a su padre.',
      year: 2019,
      rating: 6.5,
    ),
    Movie(
      title: 'Los últimos días en Marte',
      imageUrl:
          'https://image.tmdb.org/t/p/original/kxcQkAhpn8cvJTsU8PXblI5Qq8F.jpg',
      description: 'Una misión en Marte enfrenta eventos inesperados.',
      year: 2013,
      rating: 5.4,
    ),
    Movie(
      title: 'Apolo 13',
      imageUrl:
          'https://image.tmdb.org/t/p/original/wD4WBcFV6gd4hoW6OkxjNjUlxzU.jpg',
      description: 'La misión espacial que casi terminó en tragedia.',
      year: 1995,
      rating: 7.6,
    ),
    Movie(
      title: 'Uranus 2324',
      imageUrl:
          'https://image.tmdb.org/t/p/original/gZiUK88EQoe3pseBYNl8vJRRHMj.jpg',
      description:
          'Amor y despedida se entrelazan en la historia de dos almas, Kath y Lin, destinadas a estar separadas. Mientras Kath desciende a las profundidades del océano, Lin se enfrenta a una tormenta solar en la inmensidad del espacio. Sus luchas son inmensas, pero las unen en el multiverso. A pesar de sus encuentros, la felicidad les es esquiva. Cada mundo que encuentran presenta nuevas barreras, que conducen a la separación, la pérdida y el desamor. Continuamente heridas por el destino, se enfrentan al reto de superar su separación predestinada. ¿Podrán desafiar al destino, encontrar el amor verdadero y vivir felices juntas?',
      year: 2024,
      rating: 6.7,
    ),
  ];

  final PageController _pageController = PageController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPrecached) {
      for (var movie in movies) {
        precacheImage(NetworkImage(movie.imageUrl), context);
      }
      _imagesPrecached = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo animado con desvanecimiento
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Container(
              key: ValueKey<int>(currentPage),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(movies[currentPage].imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),
          ),
          // Scroll vertical con portadas y títulos
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: const CustomPageScrollPhysics(),
            itemCount: movies.length,
            onPageChanged: (int page) {
              setState(() {
                currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return MovieDetailPage(movie: movies[index]);
                      },
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;
                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: movies[index].title,
                        child: Container(
                          width: 340,
                          height: 560,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(movies[index].imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        movies[index].title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Imagen de fondo que ocupa toda la pantalla
          Hero(
            tag: movie.title,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(movie.imageUrl),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),

          // Container con estilo "glass"
          Container(
            width: 380,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1), // Opacidad para el vidrio
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                child: Container(
                  color: Colors.black.withOpacity(
                    0.2,
                  ), // Fondo semitransparente
                  child: Column(                    
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${movie.year} • ${movie.rating}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        movie.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Botón de retroceso
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
