import { Canvas } from '@react-three/fiber'
import * as THREE from 'three'
import { Perf } from 'r3f-perf'
import Background from './Background'

export default function Experience()
{
    
    return <>
    <Canvas
        dpr={0.7} //pixelRatio
        gl={{ 
            antialias: false,
            outputColorSpace: THREE.SRGBColorSpace,
            alpha: true,
        }} // renderer
        
        camera={ {
            fov: 50,
            position: [ 0, 0, 2 ],
            near: 0.1,
            far: 100
        }}
    >
        <Background />
        <Perf position="top-left" />
    </Canvas>
    </>
}