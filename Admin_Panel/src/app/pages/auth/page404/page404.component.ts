
import { Component } from '@angular/core';
import { UtilService } from './../../../services/util.service';


@Component({
  selector: 'app-page404',
  templateUrl: './page404.component.html',
  styleUrls: ['./page404.component.scss']
})
export class Page404Component {

  constructor(
    public util: UtilService,
  ) { }

}
