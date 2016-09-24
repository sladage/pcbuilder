package pcbuilder;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Configurator {

    @RequestMapping("/getcomponent")
    public Component getComponent(@RequestParam(value="id", defaultValue="0") int id) {
        return new Component(id);
    }

}
