function generateCamera() {
  let camera = new THREE.PerspectiveCamera( 75, window.innerWidth/window.innerHeight, 0.1, 1000 );
    camera.position.set( 0, 5, -30 ); // X, Y, Z
    camera.lookAt(new THREE.Vector3(0,0,0)); // look at the origin
  return camera;
}
