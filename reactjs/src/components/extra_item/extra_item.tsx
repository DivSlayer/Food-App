import StarIcon from "../../assets/svgs/star.svg";
import React from "react";
import './extra_item.scss';
import PriceFormatter from "../../utils/price_formatter";
import {Link} from "react-router-dom";
import { ExtraModel } from "../../models/extra_model";

interface props {
    item: ExtraModel;
}

const ExtrasItem: React.FC<props> = ({item}) => {
    return (
        <li className='extras-item'>
            <Link to={'/extra/' + item.uuid}>
                <div className='right'>
                    <img src={item.icon} alt={item.name} className='extras-img'/>
                </div>
                <div className='details'>
                    <p className='active'>
                        <span className='key'>{item.name}</span>
                    </p>
                    <p>
                        <span className='key'>قیمت واحد:</span>
                        <span className='value yellow-color'>{PriceFormatter(item.price!)} تومان</span>
                    </p>
                </div>
            </Link>
        </li>
    )
}

export default ExtrasItem