fvm use 3.29.1

fvm flutter clean 

fvm flutter pub get 

fvm dart run build_runner build --delete-conflicting-outputs

fvm dart run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart