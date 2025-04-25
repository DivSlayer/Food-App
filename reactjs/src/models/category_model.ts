export default class CategoryModel {
    pk: number;
    uuid: string;
    title: string;
    icon: string;

    constructor(pk:number,uuid: string, title: string, icon: string) {
        this.pk = pk;
        this.uuid = uuid;
        this.title = title;
        this.icon = icon;
    }

    static fromJSON(json: any): CategoryModel {
        return new CategoryModel(
            json.pk,
            json.uuid,
            json.title,
            json.icon,
        );
    }

    toJSON(): any {
        return {
            pk:this.pk,
            uuid: this.uuid,
            title: this.title,
            icon: this.icon,
        };
    }
}