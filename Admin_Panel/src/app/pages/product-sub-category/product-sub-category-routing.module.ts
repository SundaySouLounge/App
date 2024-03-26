
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ProductSubCategoryComponent } from './product-sub-category.component';

const routes: Routes = [
  {
    path: '',
    component: ProductSubCategoryComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProductSubCategoryRoutingModule { }
