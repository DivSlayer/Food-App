/*
File: src/hooks/useCategories.ts
Fetches available categories
*/
import { useState, useEffect } from 'react';
import CategoryModel from '../models/category_model';
import { CategoryBloc } from '../blocs/category_bloc';

export function useCategories(token: string) {
    const [categories, setCategories] = useState<CategoryModel[]>([]);

    useEffect(() => {
        async function load() {
            const result = await CategoryBloc(token);
            if (result) setCategories(result);
        }
        load();
    }, [token]);

    return categories;
}