import StarIcon from "../../assets/svgs/star.svg";
import React from "react";
import './instruction_item.scss';
import PriceFormatter from "../../utils/price_formatter";
import {Link} from "react-router-dom";
import { InstructionModel } from "../../models/instruction_model";
interface props {
    item: InstructionModel;
}

const InstructionItem: React.FC<props> = ({item}) => {
    return ( 
        <li className='instruction-item'>
            <Link to={'/instruction/' + item.uuid}>
                <div className='right'>
                    <img src={item.image} alt={item.name} className='instruction-img'/>
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

export default InstructionItem