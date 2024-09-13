import { Leva } from 'leva'
import Experience from "./scene/Experience"

export default function Application()
{
    return <>
        <Leva collapsed />
        <div className="canvas">
            <Experience />
        </div>
    </>
}
