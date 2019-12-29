import { GLTFLoader } from '/assets/js/GLTFLoader.module.js';

function generateAndAddFloatplane(scene) {
  var swordfish;
  var loader = new GLTFLoader();
  loader.load( '/assets/models/swordfish/scene.gltf', function ( gltf ) {
    swordfish = gltf.scene;
    swordfish.scale.set(0.01,0.01,0.01);
    swordfish.overrideMaterial = (new THREE.MeshLambertMaterial({
      color: 0xffffff,
      side: THREE.DoubleSide
    }));

    swordfish.position.y = -6;
    swordfish.rotation.y = Math.PI;

    scene.add( swordfish );
  });

  return swordfish;
}
