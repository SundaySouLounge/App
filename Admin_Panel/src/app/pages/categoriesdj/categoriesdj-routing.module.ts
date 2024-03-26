import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CategoriesdjComponent } from './categoriesdj.component';

const routes: Routes = [
  {
    path: '',
    component: CategoriesdjComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CategoriesdjRoutingModule { }

