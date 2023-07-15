enum PokemonType {
  normal,
  fire,
  water,
  grass,
  electric,
  ice,
  fighting,
  poison,
  ground,
  flying,
  psychic,
  bug,
  rock,
  ghost,
  dark,
  dragon,
  steel,
  fairy;

  factory PokemonType.fromName(String value) {
    final str = value.toLowerCase();
    switch (str) {
      case 'normal': return PokemonType.normal;
      case 'fire': return PokemonType.fire;
      case 'water': return PokemonType.water;
      case 'grass': return PokemonType.grass;
      case 'electric': return PokemonType.electric;
      case 'ice': return PokemonType.ice;
      case 'fighting': return PokemonType.fighting;
      case 'poison': return PokemonType.poison;
      case 'ground': return PokemonType.ground;
      case 'flying': return PokemonType.flying;
      case 'psychic': return PokemonType.psychic;
      case 'bug': return PokemonType.bug;
      case 'rock': return PokemonType.rock;
      case 'ghost': return PokemonType.ghost;
      case 'dark': return PokemonType.dark;
      case 'dragon': return PokemonType.dragon;
      case 'steel': return PokemonType.steel;
      case 'fairy': return PokemonType.fairy;
    }

    throw ArgumentError();
  }

  factory PokemonType.fromString(String value) {
    switch (value) {
      case 'PokemonType.normal': return PokemonType.normal;
      case 'PokemonType.fire': return PokemonType.fire;
      case 'PokemonType.water': return PokemonType.water;
      case 'PokemonType.grass': return PokemonType.grass;
      case 'PokemonType.electric': return PokemonType.electric;
      case 'PokemonType.ice': return PokemonType.ice;
      case 'PokemonType.fighting': return PokemonType.fighting;
      case 'PokemonType.poison': return PokemonType.poison;
      case 'PokemonType.ground': return PokemonType.ground;
      case 'PokemonType.flying': return PokemonType.flying;
      case 'PokemonType.psychic': return PokemonType.psychic;
      case 'PokemonType.bug': return PokemonType.bug;
      case 'PokemonType.rock': return PokemonType.rock;
      case 'PokemonType.ghost': return PokemonType.ghost;
      case 'PokemonType.dark': return PokemonType.dark;
      case 'PokemonType.dragon': return PokemonType.dragon;
      case 'PokemonType.steel': return PokemonType.steel;
      case 'PokemonType.fairy': return PokemonType.fairy;
    }

    throw ArgumentError();
  }
}
