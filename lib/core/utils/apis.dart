enum NetworkEndPoints {
  baseUrl(path: /*  "http://localhost:5000"  */ 'https://node-nightmodelv2.onrender.com'),
  getAllAreas(path: '/area/fetcharea'),
  saveArea(path: '/area/createarea'),
  deleteArea(path: '/area/delete_area/'),

  ///Stop
  createStop(path: '/stop/create'),
  updateNearestStop(path: '/stop/update-nearby'),
  getAllStops(path: '/stop/stops'),

  saveBus(path: '/bus/bus'),
  existedBuses(path: '/bus/existedBuses');

  final String path;
  const NetworkEndPoints({required this.path});
}
