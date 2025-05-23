import { type BaseProps, type Widget } from './widget.js';
import Gtk from 'gi://Gtk?version=3.0';
type Event<Self> = (self: Self) => void | boolean;
export type SwitchProps<Attr = unknown, Self = Switch<Attr>> = BaseProps<Self, Gtk.Switch.ConstructorProperties & {
    on_activate?: Event<Self>;
}, Attr>;
export declare function newSwitch<Attr = unknown>(...props: ConstructorParameters<typeof Switch<Attr>>): Switch<Attr>;
export interface Switch<Attr> extends Widget<Attr> {
}
export declare class Switch<Attr> extends Gtk.Switch {
    constructor(props?: SwitchProps<Attr>);
    get on_activate(): Event<this>;
    set on_activate(callback: Event<this>);
}
export default Switch;
