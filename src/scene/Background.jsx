import { useRef, useEffect, useMemo } from 'react'
import { events, useFrame } from '@react-three/fiber'
import { useTexture } from '@react-three/drei'
import { useControls } from 'leva'
import * as THREE from 'three'

import fragmentShader from './materials/backgroundMaterial/fragment.glsl'
import vertexShader from './materials/backgroundMaterial/vertex.glsl'


export default function Background()
{

    const meshRef = useRef()

    const noiseTexture = useTexture("./noiseTexture.png")


    const uniforms = {
        uTime: {value: 0},
        uResolution: {value: new THREE.Vector2(window.innerWidth, window.innerHeight)},
        uColor: {value: new THREE.Color("#CEFFFF")},
        uSecondColor: {value: new THREE.Color("#CEFFFF")},
        uBackgroundColor: {value: new THREE.Color("#000000")},
        uNoiseTexture: {value: noiseTexture}
    }

    const {innerRadius} = useControls('innerRadius', {
        innerRadius:{
            value: 2,
            min: 0,
            max: 10,
            step: 0.01,
            // onChange: (value)=>{(meshRef.current.material.uniforms.uColor.value = value )}
        }
    })

    const colors = useControls({
        Color: {  r: 206, b: 255, g: 255, a: 1, onChange:(value) =>{(
            meshRef.current.material.uniforms.uColor.value.r = value.r / 255,
            meshRef.current.material.uniforms.uColor.value.g = value.g / 255,
            meshRef.current.material.uniforms.uColor.value.b = value.b / 255
        )} },
        SecondCold: { r: 0, b: 122, g: 122, a: 1, onChange:(value) =>{(
            meshRef.current.material.uniforms.uSecondColor.value.r = value.r / 255,
            meshRef.current.material.uniforms.uSecondColor.value.g = value.g / 255,
            meshRef.current.material.uniforms.uSecondColor.value.b = value.b / 255
        )} },
        BackgroundColor: { r: 0, b: 0, g: 0, a: 1, onChange:(value) =>{(
            meshRef.current.material.uniforms.uBackgroundColor.value.r = value.r / 255,
            meshRef.current.material.uniforms.uBackgroundColor.value.g = value.g / 255,
            meshRef.current.material.uniforms.uBackgroundColor.value.b = value.b / 255
        )} },
      })

    useFrame((state, delta)=>{
        meshRef.current.material.uniforms.uTime.value += delta * 0.3
    })

    window.addEventListener('resize', ()=>{
        meshRef.current.material.uniforms.uResolution.value.x = window.innerWidth
        meshRef.current.material.uniforms.uResolution.value.y = window.innerHeight
    })

    return <>
        <mesh ref={meshRef} >
            <planeGeometry args={[1, 1]} />
            <shaderMaterial fragmentShader={fragmentShader} transparent={true} vertexShader={vertexShader} uniforms={uniforms} />
        </mesh>
    </>
}