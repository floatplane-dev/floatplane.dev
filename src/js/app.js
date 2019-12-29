// const isProduction = location.host === 'floatplane.io' ? true : false;
// const environment = isProduction ? 'production' : 'development';

// Fire page view to Google Analytics
// if (ga) {
//   ga('create', 'UA-34474019-10', 'auto');
//   ga('set', {
//     dimension1: environment
//   });
//   ga('send', 'pageview');
// }

/*
  global
  generateScene,
  generateCamera,
  generateRenderer,
  generateCube,
  generateWater,
  generateLight,
  Water
*/

document.addEventListener("DOMContentLoaded", function() {

  const scene = generateScene();
  const camera = generateCamera();
  const renderer = generateRenderer();
  const cube = generateCube();
  const light = generateLight();
  const water = generateWater(scene, light);

	scene.add( light );
	scene.add( water );
  scene.add(cube);

  scene.background = new THREE.Color( 0x333333 );

  var animate = function () {
    requestAnimationFrame( animate );

    cube.rotation.x += 0.01;
    cube.rotation.y += 0.01;
    water.material.uniforms[ 'time' ].value += 0.5 / 60.0;

    renderer.render( scene, camera );
  };

  document.getElementById('homepage').appendChild( renderer.domElement );
  animate();
});
