# Street-Report

Este proyecto Flutter permite a los usuarios reportar el mal estado de las vías y a las entidades realizar solicitudes de arreglo en áreas específicas. Utiliza la API de MapBox para mostrar un mapa interactivo en la aplicación.

## Funcionalidades

### Usuarios
- **Reporte de Mal Estado:** Los usuarios pueden reportar vías con problemas, como baches, interrupciones, o cualquier otro deterioro.
- **Vía Cerrada:** Posibilidad de marcar una vía como cerrada temporalmente.

### Entidades
- **Solicitudes de Arreglo:** Las entidades pueden registrar la necesidad de realizar trabajos de mantenimiento o reparación en una vía específica.

## Funcionamiento

### Vista de Usuario
- **Reporte de Mal Estado:** Permite agregar un marcador en el mapa indicando el mal estado de una vía.
- **Vía Cerrada:** Permite marcar una vía como cerrada temporalmente.

### Vista de Entidades
- **Visualización de Solicitudes:** Muestra en el mapa las áreas donde las entidades han reportado la necesidad de realizar arreglos.

## Uso de MapBox API

La aplicación utiliza la API de MapBox para:
- Visualizar un mapa interactivo en la aplicación.
- Marcar ubicaciones específicas relacionadas con los reportes de vías con mal estado y las solicitudes de arreglo.

## Configuración

1. Clona este repositorio.
2. Asegúrate de tener las claves de acceso a la API de MapBox.
3. Coloca tu clave de acceso en el archivo de configuración correspondiente (`config.dart` o similar).
4. Ejecuta la aplicación en un emulador o dispositivo compatible con Flutter.

## Contribuciones

¡Las contribuciones son bienvenidas! Si deseas mejorar esta aplicación, no dudes en enviar pull requests.

## Recursos Adicionales

- Documentación de [MapBox API](https://docs.mapbox.com/api/overview/)

## Licencia

[MIT License](LICENSE)

