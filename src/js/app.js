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
  generateLight,
  generateWater,
  generateCube,
  generateAndAddSky,
  generateAndAddFloatplane,
*/

document.addEventListener("DOMContentLoaded", function() {

  const scene = generateScene();
  const camera = generateCamera();
  const renderer = generateRenderer();
  const light = generateLight();
  const cube = generateCube();
  const water = generateWater(scene, light);

  generateAndAddSky(scene, renderer, water, light);
  generateAndAddFloatplane(scene);

	scene.add( light );
	scene.add( water );

  var animate = function () {
    requestAnimationFrame( animate );

    light.rotation.x += 0.01;
    water.material.uniforms[ 'time' ].value += 0.5 / 60.0;

    renderer.render( scene, camera );
  };

  window.addEventListener( 'resize', onWindowResize, false );

  function onWindowResize() {
		camera.aspect = window.innerWidth / window.innerHeight;
		camera.updateProjectionMatrix();

		renderer.setSize( window.innerWidth, window.innerHeight );
	}

  document.getElementById('homepage').appendChild( renderer.domElement );
  animate();
});
