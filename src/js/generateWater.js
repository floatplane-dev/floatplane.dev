import { Water } from '/assets/js/Water.module.js';

function generateWater(scene, light) {
  let waterGeometry = new THREE.PlaneBufferGeometry( 10000, 10000 );

  let water = new Water(
		waterGeometry,
		{
			textureWidth: 512,
			textureHeight: 512,
			waterNormals: new THREE.TextureLoader().load( 'assets/images/waternormals.jpg', function ( texture ) {

				texture.wrapS = texture.wrapT = THREE.RepeatWrapping;

			} ),
			alpha: 1.0,
			sunDirection: light.position.clone().normalize(),
			sunColor: 0xffffff,
			waterColor: 0x001e0f,
			distortionScale: 3.7,
			fog: scene.fog !== undefined
		}
	);

  water.rotation.x = - Math.PI / 2;
	water.position.y = -6;

  return water;
}
