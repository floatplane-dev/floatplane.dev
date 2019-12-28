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
  generateRenderer,
  generateCamera,
  generateCube,
  generateScene
*/

document.addEventListener("DOMContentLoaded", function() {
  
  const scene = generateScene();
  const camera = generateCamera();
  const renderer = generateRenderer();

  scene.background = new THREE.Color( 0x333333 );
  scene.add( generateCube() );

  var animate = function () {
    requestAnimationFrame( animate );

    cube.rotation.x += 0.01;
    cube.rotation.y += 0.01;

    renderer.render( scene, camera );
  };

  document.getElementById('homepage').appendChild( renderer.domElement );
  animate();
});
