function generateCube() {
  var geometry = new THREE.BoxGeometry( 1, 1, 1 );
  var material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );
  let cube = new THREE.Mesh( geometry, material );
  return cube;
}
