/*
File: src/hooks/useFood.ts
Handles fetching, updating, deleting a single food item
*/
import { useState, useEffect } from 'react';
import axios from 'axios';
import Links from '../utils/links';
import { FoodModel } from '../models/food_model';
import {FoodBloc} from "../blocs/food_bloc";

export function useFood(uuid: string, token: string) {
    const [food, setFood] = useState<FoodModel | null>(null);
    const [loading, setLoading] = useState<boolean>(true);

    useEffect(() => {
        async function fetch() {
            try {
                const item = await FoodBloc(token, uuid).then(
                    (res)=>{
                        return res!==null && res.length >0 ? res[0] : null;
                    }
                );
                setFood(item || null);
            } finally {
                setLoading(false);
            }
        }
        fetch();
    }, [uuid, token]);

    const update = async (data: Record<string, any>) => {
        const response = await axios.put(
            Links.foodLink(uuid), data,
            { headers: { Authorization: `Bearer ${token}` } }
        );
        setFood(FoodModel.fromJson(response.data));
    };

    const remove = async () => {
        await axios.delete(
            Links.foodLink(uuid),
            { headers: { Authorization: `Bearer ${token}` } }
        );
    };

    return { food, loading, update, remove,setFood };
}
