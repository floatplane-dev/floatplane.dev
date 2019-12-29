import { Sky } from '/assets/js/Sky.module.js';

function generateSky(scene, renderer, water, light) {
  var sky = new Sky();

	var uniforms = sky.material.uniforms;

	uniforms[ 'turbidity' ].value = 10;
	uniforms[ 'rayleigh' ].value = 2;
	uniforms[ 'luminance' ].value = 1;
	uniforms[ 'mieCoefficient' ].value = 0.005;
	uniforms[ 'mieDirectionalG' ].value = 0.8;

	var parameters = {
		distance: 400,
		inclination: 0.49,
		azimuth: 0.205
	};

	var cubeCamera = new THREE.CubeCamera( 0.1, 1, 512 );
	cubeCamera.renderTarget.texture.generateMipmaps = true;
	cubeCamera.renderTarget.texture.minFilter = THREE.LinearMipmapLinearFilter;

	scene.background = cubeCamera.renderTarget;

	function updateSun() {

		var theta = Math.PI * ( parameters.inclination + 0.55 ); // vary between +0.5 and +0.6, originally was -0.5
		var phi = 2 * Math.PI * ( parameters.azimuth - 0.5 );

		light.position.x = parameters.distance * Math.cos( phi );
		light.position.y = parameters.distance * Math.sin( phi ) * Math.sin( theta );
		light.position.z = parameters.distance * Math.sin( phi ) * Math.cos( theta );

		sky.material.uniforms[ 'sunPosition' ].value = light.position.copy( light.position );
		water.material.uniforms[ 'sunDirection' ].value.copy( light.position ).normalize();

		cubeCamera.update( renderer, sky );

	}

	updateSun();

  return sky;
}
