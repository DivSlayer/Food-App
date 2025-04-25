import Links from "../utils/links";
import SearchModel from "../models/search_model";

export async function SearchBloc(accessToken: string, value: string): Promise<SearchModel | null> {
    const link: string = Links.searchLink(value);
    const response = await fetch(link, {
        method: 'GET',
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
    });
    if (response.ok) {
        let json_converted = await response.json();
        return SearchModel.fromJson(json_converted);
    }
    return null;
}