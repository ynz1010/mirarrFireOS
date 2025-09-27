// Inside your ListView.builder for movie results:
ListView.builder(
  itemCount: movieResults.length,
  itemBuilder: (context, index) {
    final movie = movieResults[index];
    return FocusableActionDetector(
      onFocusChange: (focused) {
        setState(() {});
      },
      onKey: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.select) {
          Platform.isAndroid || Platform.isIOS
              ? onTapMovie(movie.title, movie.id, context)
              : onTapMovieDesktop(movie.title, movie.id, context);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Focus.of(context).hasFocus ? Colors.yellow : Colors.transparent,
            width: 2,
          ),
        ),
        child: MovieSearchResult(movie: movie),
      ),
    );
  },
),
