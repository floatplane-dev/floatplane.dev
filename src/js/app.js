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

/* global generateRenderer, generateCamera */

document.addEventListener("DOMContentLoaded", function() {
  var scene = new THREE.Scene();

  const camera = generateCamera();
  const renderer = generateRenderer();

  document.getElementById('homepage').appendChild( renderer.domElement );

  scene.background = new THREE.Color( 0x333333 );

  var geometry = new THREE.BoxGeometry( 1, 1, 1 );
  var material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );

  var cube = new THREE.Mesh( geometry, material );
  scene.add( cube );

  var animate = function () {
    requestAnimationFrame( animate );

    cube.rotation.x += 0.01;
    cube.rotation.y += 0.01;

    renderer.render( scene, camera );
  };

  animate();
});
