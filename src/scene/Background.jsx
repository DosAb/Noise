import { useRef, useEffect, useMemo } from 'react'
import { events, useFrame } from '@react-three/fiber'
import { useTexture } from '@react-three/drei'
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
        uColor: {value: new THREE.Vector3(0)},
        uNoiseTexture: {value: noiseTexture}
    }


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