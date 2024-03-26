
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ProductsStatsComponent } from './products-stats.component';

const routes: Routes = [
  {
    path: '',
    component: ProductsStatsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProductsStatsRoutingModule { }
