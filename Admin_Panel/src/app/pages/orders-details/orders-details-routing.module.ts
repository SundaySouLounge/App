
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { OrdersDetailsComponent } from './orders-details.component';

const routes: Routes = [
  {
    path: '',
    component: OrdersDetailsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class OrdersDetailsRoutingModule { }
