import {ReactElement} from "react";

export class NavModel {
    link: string;
    svg: ReactElement;
    label: string;


    constructor({link, svg, label}: { link: string, svg: ReactElement, label: string }) {
        this.link = link;
        this.svg = svg;
        this.label = label;
    }
}
