# pawkar_app

A new Flutter project.

# flutter version
 3.35.5 


# Generar Firma de la Aplicación (Keystore)
1.- Instalar android studio
2.- Ir a configuracion -> Lenguajes y Frameworks -> Android SDK -> SDK Tools -> activar     Andorid SDK  Command Line tools
3.- Abrir cmd y ejecutar flutter doctor --android-licenses y aceptar todo
4.- cd C:\Program Files\Android\Android Studio\jbr\bin
5.- ./keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
6.- Copiar upload-keystore de C:\Users\nombre-usuario\  y pegar en C:\Users\usuario\Documents\Flutter\pawkar_app\android\app
7.- Editar build.gradle.kts

# Ejecutar comando para poder generar compilado android 

flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter build appbundle
