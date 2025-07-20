 use 3.29.1

 flutter clean 

 flutter pub get 

 dart run build_runner build --delete-conflicting-outputs

#  dart run build_runner watch --delete-conflicting-outputs

 dart run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart