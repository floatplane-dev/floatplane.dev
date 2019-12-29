function generateCube() {
  var geometry = new THREE.BoxGeometry( 5, 5, 5 );
  var material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );
  let cube = new THREE.Mesh( geometry, material );
  return cube;
}
