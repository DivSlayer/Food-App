/*
File: src/components/FoodForm.tsx
Form for editing name, details, time, and category
*/
import React, {useRef, FormEvent} from 'react';
import CategoryModel from "../../../models/category_model";
import FormGroup from "../../../components/forms/form-group";
import SizesList from "./sizes_list";
import {FoodModel} from "../../../models/food_model";

interface Props {
    data: FoodModel;
    setData: (d: Record<string, any>) => void;
    categories: CategoryModel[];
    onSubmit: (d: Record<string, any>) => void;
}

export default function FoodForm({data, setData, categories, onSubmit}: Props) {
    const formRef = useRef<HTMLFormElement>(null);

    const handle = (e: FormEvent) => {
        e.preventDefault();
        onSubmit(data);
    };

    return (
        <form ref={formRef} onSubmit={handle} className="form">
            <FormGroup label="نام غذا" name="name" value={data.name}
                       update={(v) => setData({...data, name: v})}/>

            <FormGroup label="ترکیبات" name="details" useTextarea value={data.details}
                       update={(v) => setData({...data, details: v})}/>

            <FormGroup label="زمان آماده سازی" name="preparation_time" keyboardType="number"
                       value={data.preparationTime?.toString()}
                       update={(v) => setData({...data, preparation_time: v})}/>

            <FormGroup label="دسته بندی" name="category_id" useSelect value={"1"}
                       update={(v) => setData({...data, category_id: v})}>
                {categories.map(c => (
                    <option key={c.pk} value={c.pk}>{c.title}</option>
                ))}
            </FormGroup>

            <SizesList sizes={data.sizes} foodUUID={data.uuid}/>
            <button type="submit" className="btn yellow-btn submit-btn">ذخیره</button>
        </form>
    );
}

