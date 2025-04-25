import React, {ReactNode} from "react";
import './_btns.scss'

interface ButtonProps {
    children?: ReactNode;
    label: string;
    classname?: string;

    onClick(e: React.MouseEvent | React.TouchEvent): void;

    svg?: string;
    img?: string;
}

export const ButtonIcon: React.FC<ButtonProps> = ({
                                                      label,
                                                      classname = "",
                                                      onClick,
                                                      svg = null,
                                                      img = null,
                                                      children = null
                                                  }) => {
    return (
        <button className={'btn ' + classname} onClick={onClick}>
            <span>{label}</span>
            {svg ?? <></>}
            {img ? <img src={img} alt='img'/> : <></>}
            {children ?? <></>}
        </button>
    )
}