# pawkar_app

A new Flutter project.

# flutter version
 3.35.5 


# Generar Firma de la Aplicación (Keystore)
1.- cd C:\Program Files\Android\Android Studio\jbr\bin
2.- ./keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
3.- Copiar upload-keystore de C:\Users\nombre-usuario\  y pegar en C:\Users\usuario\Documents\Flutter\pawkar_app\android\app
4.- Editar build.gradle.kts

# Ejecutar comando para poder generar compilado android 

flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter build appbundle
