import { useRef, useEffect, useMemo } from 'react'
import { events, useFrame } from '@react-three/fiber'
import { useTexture } from '@react-three/drei'
import { useControls } from 'leva'
import * as THREE from 'three'
import gsap from 'gsap'

import fragmentShader from './materials/backgroundMaterial/fragment.glsl'
import vertexShader from './materials/backgroundMaterial/vertex.glsl'


export default function Background()
{

    const mm = gsap.matchMedia()

    const meshRef = useRef()
    const noiseTexture = useTexture("./noiseTexture.png")
    const mouse = new THREE.Vector2(0, 0)
    const lerpedVector = new THREE.Vector2(1.0, 0.5)
    
    window.addEventListener('mousemove', (event)=>{
        mouse.x = (event.clientX / window.innerWidth) 
        mouse.y = ((event.clientY / window.innerHeight))
    })


    const uniforms = {
        uTime: {value: 0},
        uResolution: {value: new THREE.Vector2(window.innerWidth, window.innerHeight)},
        uColor: {value: new THREE.Color("#32FFFF")},
        uSecondColor: {value: new THREE.Color("#25B9FF")},
        uInnerColor: {value: new THREE.Color("#0087FF")},
        uBackgroundColor: {value: new THREE.Color("#ffffff")},
        uSpeed: {value: 1},
        uMobile: {value: 0},
        uRandom: {value: Math.random()},
        uMouse: {value: lerpedVector},
        uNoiseTexture: {value: noiseTexture}
    }

    const speed = useControls({
        speed:{
            value: 1,
            min: 0,
            max: 10,
            step: 0.01,
            onChange:(value) =>{(meshRef.current.material.uniforms.uSpeed.value = value)}
        }
    })

    const colors = useControls({
        Color: {  r: 20, b: 255, g: 255, a: 1, onChange:(value) =>{(
            meshRef.current.material.uniforms.uColor.value.r = value.r / 255,
            meshRef.current.material.uniforms.uColor.value.g = value.g / 255,
            meshRef.current.material.uniforms.uColor.value.b = value.b / 255
        )} },
        OuterColor: { r: 37, b: 255, g: 135, a: 1, onChange:(value) =>{(
            meshRef.current.material.uniforms.uSecondColor.value.r = value.r / 255,
            meshRef.current.material.uniforms.uSecondColor.value.g = value.g / 255,
            meshRef.current.material.uniforms.uSecondColor.value.b = value.b / 255
        )} },
        InnerColor: { r: 0, b: 255, g: 86, a: 1, onChange:(value) =>{(
            meshRef.current.material.uniforms.uInnerColor.value.r = value.r / 255,
            meshRef.current.material.uniforms.uInnerColor.value.g = value.g / 255,
            meshRef.current.material.uniforms.uInnerColor.value.b = value.b / 255
        )} },
        BackgroundColor: { r: 255, b: 255, g: 255, a: 1, onChange:(value) =>{(
            meshRef.current.material.uniforms.uBackgroundColor.value.r = value.r / 255,
            meshRef.current.material.uniforms.uBackgroundColor.value.g = value.g / 255,
            meshRef.current.material.uniforms.uBackgroundColor.value.b = value.b / 255
        )} },
      })

    useFrame((state, delta)=>{
        meshRef.current.material.uniforms.uTime.value += delta * 0.3

        lerpedVector.x += (mouse.x - lerpedVector.x) /(30 * (1 / meshRef.current.material.uniforms.uSpeed.value))
        lerpedVector.y += (mouse.y - lerpedVector.y) /(30 * (1 / meshRef.current.material.uniforms.uSpeed.value))
    })

    window.addEventListener('resize', ()=>{
        meshRef.current.material.uniforms.uResolution.value.x = window.innerWidth
        meshRef.current.material.uniforms.uResolution.value.y = window.innerHeight
    })
    
    useEffect(()=>{
        mm.add("(min-width: 426px)", () => {
            console.log("not mobile")
            if(meshRef.current)
            {
                meshRef.current.material.uniforms.uMobile.value = 0
            }
            // this setup code only runs when viewport is at least 800px wide
        })
        mm.add("(max-width: 426px)", () => {
            console.log("mobile")
            if(meshRef.current)
            {
                meshRef.current.material.uniforms.uMobile.value = 1
            }
            // this setup code only runs when viewport is at least 800px wide
        })
    },[])

    return <>
        <mesh ref={meshRef} >
            <planeGeometry args={[1, 1]} />
            <shaderMaterial precision="lowp" fragmentShader={fragmentShader} transparent={true} vertexShader={vertexShader} uniforms={uniforms} />
        </mesh>
    </>
}