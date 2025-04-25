import {Routes, useLocation} from "react-router-dom";
import TopBarProgress from "react-topbar-progress-indicator";
import {useEffect, useState} from "react";

export default function CustomSwitch({children}) {
    const [progress, setProgress] = useState(false)
    const [prevLoc, setPrevLoc] = useState("")
    const location = useLocation()
    useEffect(() => {
        setPrevLoc(location.pathname)
        setProgress(true)
        if (location.pathname === prevLoc) {
            setPrevLoc('')
        }
    }, [location])

    useEffect(() => {
        setProgress(false)
    }, [prevLoc])
    TopBarProgress.config({
        barColors: {
            "0": "#00ff95",
            "1.0": "#006eff"
        },
        shadowBlur: 5
    });
    return (
        <>
            {
                progress && <TopBarProgress/>
            }
            <Routes>
                {children}
            </Routes>
        </>
    )
}